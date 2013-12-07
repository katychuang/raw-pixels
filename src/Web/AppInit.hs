{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Web.AppInit
  ( app
  ) where

------------------------------------------------------------------------------
import           Control.Applicative
import           Control.Monad.State
import qualified Data.Configurator                           as C
import           Data.Monoid
import qualified Data.Text                                   as T
import           Data.Text.Encoding
import qualified Database.Groundhog.Postgresql               as GH
import           Heist
import           Heist.Compiled
import           Snap.Core
import           Snap.Extras
import           Snap.Extras.NavTrails
import           Snap.Extras.SpliceUtils.Compiled
import           Snap.Restful
import           Snap.Snaplet
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Auth.Backends.PostgresqlSimple
import           Snap.Snaplet.Heist.Compiled
import           Snap.Snaplet.PostgresqlSimple
import           Snap.Snaplet.Session.Backends.CookieSession
------------------------------------------------------------------------------
import           Web.App.Profiles
import           Web.Application
import           Web.Routes
import           Web.Sessions
--import           Web.App.Tenants
--import           App.Combo
import           Web.App.Users
------------------------------------------------------------------------------


titleSplice :: Splice AppHandler
titleSplice = return $ yieldRuntimeText $ do
    lift $ liftM f $ gets _titleFragment
  where
    site = "Snap Project Template"
    f Nothing = site
    f (Just t) = T.concat [t, " - ", site]


compiledSplices :: Splices (Splice (Handler App App))
compiledSplices = do
    compiledAuthSplices auth
--    tenantSplices
    userSplices
    "pageTitle"     #! titleSplice
    "loginForm"     #! loginFormSplice
    "profileForm"   #! profileFormSplice
    "passwordForm"  #! passwordFormSplice
--    "tenantForm"    #! tenantEditFormSplice
    "rqparam"       #! paramSplice
    "staticscripts" #! scriptsSplice "static/js" "/static/"
    "currentUser"   #! withSplices runChildren userCSplices $ lift $
                       maybe pass return =<< with auth currentUser


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    h <- nestSnaplet "" heist $ heistInit' "" $
           mempty { hcLoadTimeSplices = defaultLoadTimeSplices
                  , hcCompiledSplices = mconcat [ compiledSplices
                                                , resourceCSplices usersR ]
                  }
    s <- nestSnaplet "sess" sess $
           initCookieSessionManager "site_key.txt" "sess" (Just 3600)

    cfg <- C.subconfig "postgresql-simple" <$> getSnapletUserConfig
    p <- nestSnaplet "pgs" pgs $ pgsInit' cfg

    connstr <- liftIO $ decodeUtf8 <$> getConnectionString cfg
    printInfo $ T.concat ["Initializing groundhog with connstr ", connstr]
    ghPool <- liftIO $ GH.withPostgresqlPool (T.unpack connstr) 3 return
--    printInfo "Checking for database migrations"
--    liftIO $ GH.runDbConn migrateTelescope ghPool

    a <- nestSnaplet "auth" auth $ initPostgresAuth sess p

    addRoutes routes
--    addTenantsR h

    exts <- nestSnaplet "" extras $ initExtras h sess
    nt <- nestSnaplet "" navTrail $ initNavTrail sess (Just h)
    initFlashNotice h sess
    return $ App h s p ghPool a exts nt Nothing Nothing

