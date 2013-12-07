{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE UndecidableInstances       #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  App.Combo
-- Copyright   :  Soostone Inc
-- License     :  BSD3
--
-- Maintainer  :  admin@soostone.com
-- Stability   :  experimental
--
-- Following the Haskell philosophy of least context needed, this
-- module is meant to encapsulate the common computation context used
-- in your application, independent of the web front-end. It will be
-- present both within the Web layer, but also within the
-- web-independent background processing layer.
--
-- As an example, you may keep several database/API connections within
-- the state here: Groundhog, postgresql-simple, redis, cassandra,
-- twitter API, etc.
----------------------------------------------------------------------------

module App.Combo where

-------------------------------------------------------------------------------
import           Control.Applicative
import           Control.Monad.Base
import           Control.Monad.Logger
import           Control.Monad.Reader
import           Control.Monad.Trans.Control
import qualified Data.ByteString.Char8         as B
import qualified Data.Configurator             as C
import qualified Data.Configurator.Types       as C
import           Data.Monoid
import           Data.Pool
import qualified Database.Groundhog.Postgresql as GH
import           Snap.Snaplet.PostgresqlSimple (getConnectionString)
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- | A monad that has access to all the common environment we
-- typically need in this application, including redis, postgres, an
-- RNG, etc.
newtype Combo m a = Combo { unCombo :: ReaderT ComboState m a }
  deriving (MonadReader ComboState, Monad, MonadIO,
            MonadTrans, Functor, Applicative)


instance MonadTransControl Combo where
     newtype StT Combo a = StCombo {unStCombo :: StT (ReaderT ComboState) a}
     liftWith = defaultLiftWith Combo unCombo StCombo
     restoreT = defaultRestoreT Combo unStCombo


instance MonadBase b m => MonadBase b (Combo m) where
    liftBase = liftBaseDefault


instance MonadBaseControl b m => MonadBaseControl b (Combo m) where
     newtype StM (Combo m) a = StMCombo {unStMCombo :: ComposeSt Combo m a}
     liftBaseWith = defaultLiftBaseWith StMCombo
     restoreM     = defaultRestoreM   unStMCombo


-------------------------------------------------------------------------------
-- | Run a Combo computation
runCombo :: ComboState -> Combo m a  -> m a
runCombo cs f = runReaderT (unCombo f) cs


-------------------------------------------------------------------------------
-- | Execute a Combo computation within given Environment.
execCombo :: String -> Combo IO b -> IO b
execCombo env f = mkComboStateEnv env >>= flip runCombo f


-------------------------------------------------------------------------------
-- | Add all the state needed to perform common computations in your
-- application. Some valid examples are intentionally commented out to
-- guide you.
data ComboState = ComboState {
      csGH :: Pool GH.Postgresql
    -- , csRedis :: H.Connection
    -- , csRNG   :: RNG
    -- , csMgr   :: Manager
    }


-------------------------------------------------------------------------------
-- | Configure ComboState from given Environment.
--
-- Example: @devel@ if you want to load a 'devel.conf'
mkComboStateEnv :: String -> IO ComboState
mkComboStateEnv env = do
    conf <- C.load [C.Required (env <> ".cfg")]
    mkComboState conf


-------------------------------------------------------------------------------
-- | Configure ComboState from given 'Config'; helpful for loading as
-- part of the Snap app. It will look for a 'postgresql-simple'
-- portion within the 'Config' given.
mkComboState :: C.Config -> IO ComboState
mkComboState conf = do

    let cfg = C.subconfig "postgresql-simple" conf
    connstr <- liftIO $ getConnectionString cfg
    ghPool <- liftIO $ GH.withPostgresqlPool (B.unpack connstr) 3 return

    return $ ComboState ghPool


-------------------------------------------------------------------------------
-- | Perform groundhog op within Combo.
cGH :: (MonadIO m, MonadReader ComboState m)
    => GH.DbPersist GH.Postgresql (NoLoggingT IO) b
    -> m b
cGH f = do
    c <- asks csGH
    liftIO $ GH.runDbConn f c
