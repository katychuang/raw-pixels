{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE PackageImports        #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

------------------------------------------------------------------------------
-- | This module defines our application's state type and an alias for its
-- handler monad.
module Web.Application where

------------------------------------------------------------------------------
import           Control.Lens
import           Control.Monad.Logger
import           Control.Monad.Reader
import           Control.Monad.State
import "resource-pool" Data.Pool
import qualified Data.Text as T
import           Data.Time
import           Database.Groundhog.Core hiding (get)
import           Database.Groundhog.Postgresql hiding (get)
import           Snap.Core
import           Snap.Extras.CoreUtils
import           Snap.Extras.NavTrails
import           Snap.Snaplet
import           Snap.Snaplet.Heist.Compiled
import           Snap.Snaplet.Auth
import           Snap.Snaplet.PostgresqlSimple
import           Snap.Snaplet.Session
------------------------------------------------------------------------------


------------------------------------------------------------------------------
data App = App
    { _heist           :: Snaplet (Heist App)
    , _sess            :: Snaplet SessionManager
    , _pgs             :: Snaplet Postgres
    , _gh              :: Pool Postgresql
    , _auth            :: Snaplet (AuthManager App)
    , _extras          :: Snaplet ()
    , _navTrail        :: Snaplet (NavTrail App)
    , _nowCache        :: Maybe UTCTime
    -- ^ Request-local now cache so we don't do 100 syscalls
    , _titleFragment   :: Maybe T.Text
    }

makeLenses ''App

instance HasHeist App where
    heistLens = subSnaplet heist

instance HasPostgres (Handler b App) where
    getPostgresState = with pgs get

-- Use this when we switch to groundhog backed by a postgresql-simple pool
--getDbPool = pgPool . view snapletValue . _db
--
--instance ConnectionManager (Pool Connection) Postgresql where
--  withConn f pconn = withResource pconn $ withConn f . Postgresql
--  withConnNoTransaction f pconn =
--    withResource pconn $ withConnNoTransaction f . Postgresql

instance ConnectionManager App Postgresql where
  withConn f app = withConn f (_gh app)
  withConnNoTransaction f app = withConnNoTransaction f (_gh app)

------------------------------------------------------------------------------
type AppHandler = Handler App App


runGH :: ConnectionManager b conn
    => DbPersist conn (NoLoggingT IO) a
    -> Handler b v a
runGH f = withTop' id $ do
    cm <- ask
    liftIO $ runNoLoggingT (withConn (runDbPersist f) cm)


-------------------------------------------------------------------------------
getTime :: AppHandler UTCTime
getTime = do
    mt <- gets _nowCache
    case mt of
      Just t -> return t
      Nothing -> do
          now <- liftIO getCurrentTime
          modify $ nowCache .~ Just now
          return now


                           -------------------------
                           -- Page Title Fragment --
                           -------------------------

setFocus' :: Handler App App ()
setFocus' = with navTrail setFocus


setTitle :: MonadState App m => T.Text -> m ()
setTitle t = modify $ titleFragment .~ Just t

clearTitle :: MonadState App m => t -> m ()
clearTitle _ = modify $ titleFragment .~ Nothing


-------------------------------------------------------------------------------
-- | Take a Maybe x operation that is dependent on a user being logged in.
-- Remove the maybe, covering the Nothing case by short-circuiting
-- the Response and warning the user that they need to be logged in.
--
-- This is so we don't constantly deal with Maybe values when we know
-- they can't be if the user is properly logged in and if the
-- authentication system is working.
authenticated :: MonadSnap m => m (Maybe b) -> m b
authenticated f = do
  res <- f
  case res of
    Just res' -> return res'
    Nothing -> badReq "You must be authenticated to view this page."


