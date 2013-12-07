{-# LANGUAGE OverloadedStrings #-}

module Web.Routes where

------------------------------------------------------------------------------
import           Control.Arrow
import           Data.ByteString             (ByteString)
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist.Compiled
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Web.Admin
import           Web.Application
import           Web.Sessions
import           Web.App.Profiles
import           Web.App.Users
------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = authenticatedRoutes ++ publicRoutes


publicRoutes :: [(ByteString, Handler App App ())]
publicRoutes =
    [ ("", ifTop homeH)
    , ("sessions/new",     method GET sessionsNewH)
    , ("sessions",         ifTop (method POST loginH))
    , ("sessions/destroy", ifTop logoutH)

    -- We don't have any links to this, but it can be used to manually create
    -- users.
    , ("new_user",         failIfNotLocal $ with auth createUserH)
    , ("static",           serveDirectory "static")
    , ("heistReload",      failIfNotLocal $ with heist heistReloader)
    , ("browse",           render "instagram")
    , ("nutrition",        render "nutrition")
    , ("hello",            render "hello")
    ]


-- | Must be logged-in to access these routes
authenticatedRoutes :: [(ByteString, Handler App App ())]
authenticatedRoutes = requireLogin $
    [ ("profile",                ifTop $ method GET profileH)
    , ("profile/edit",           ifTop editProfileH)
    , ("profile/changePassword", ifTop passwordH)
    , ("admin",                  ifTop $ render "admin/index")
    ] ++ usersRRoutes


requireLogin :: [(d, Handler App v ())] -> [(d, Handler App v ())]
requireLogin = map . second $ requireUser auth needLoginH


homeH :: Handler App App ()
homeH = render "/index"

