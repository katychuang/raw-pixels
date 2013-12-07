{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RecordWildCards           #-}


module Web.Sessions where


-------------------------------------------------------------------------------
import           Control.Applicative
import           Control.Monad.Reader
import           Data.Monoid
import           Data.Text                   (Text)
import qualified Data.Text.Encoding          as T
import           Heist.Compiled
import           Snap.Core
import           Snap.Extras
import           Snap.Snaplet
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist.Compiled
import           Snap.Snaplet.Session
import           Text.Digestive
import           Text.Digestive.Heist.Compiled
import           Text.Digestive.Snap
-------------------------------------------------------------------------------
import           Web.Application
-------------------------------------------------------------------------------


                                --------------
                                -- Handlers --
                                --------------

-------------------------------------------------------------------------------
sessionsNewH :: HasHeist b => Handler b v ()
sessionsNewH = render "sessions/new"


-------------------------------------------------------------------------------
loginH :: AppHandler ()
loginH = do
  (_,r) <- runLoginForm
  case r of
    Nothing -> do
      flashError sess
        "Login has failed. Please check your credentials and try again."
      sessionsNewH --redirect "/sessions/new"
    Just _ -> do
      flashSuccess sess "Login successful."
      redirectReferer --redirect "/"

-------------------------------------------------------------------------------
needLoginH :: HasHeist b => Handler b v ()
needLoginH = sessionsNewH --redirect "/sessions/new"

-------------------------------------------------------------------------------
logoutH :: Handler App App a
logoutH = do
  with auth logout
  with sess $ resetSession >> commitSession
  redirect "/"

                                  -----------
                                  -- Forms --
                                  -----------


data LoginData
   =  LoginData
   {  emailAddress :: Text
   ,  password :: Text
   ,  rememberMe :: Bool }

-------------------------------------------------------------------------------
loginForm :: Form Text (Handler App App) AuthUser
loginForm = validateM checkLogin $ LoginData
  <$> "email"    .: text Nothing
  <*> "pass"     .: text Nothing
  <*> "remember" .: bool (Just True)


-------------------------------------------------------------------------------
checkLogin :: LoginData -> Handler App App (Result Text AuthUser)
checkLogin LoginData{..} = with auth $ do
  res <- loginByUsername emailAddress
                         (ClearText . T.encodeUtf8 $ password)
                         rememberMe
  return $ either (const $ Error "Login failed") Success res

loginFormName :: Text
loginFormName = "login-form"

runLoginForm :: Handler App App (View Text, Maybe AuthUser)
runLoginForm = runForm loginFormName loginForm

loginFormSplice :: Splice (Handler App App)
loginFormSplice = formSplice mempty mempty (lift $ liftM fst runLoginForm)


