{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RecordWildCards           #-}

module Web.App.Profiles
    ( profileH
    , editProfileH
    , passwordH
    , profileFormSplice
    , passwordFormSplice
    ) where


-------------------------------------------------------------------------------
import           Control.Applicative
import           Control.Monad.Reader
import           Data.ByteString                       (ByteString)
import qualified Data.ByteString as B
import           Data.Maybe
import           Data.Monoid
import           Data.Text             (Text)
import qualified Data.Text.Encoding    as T
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Heist.Compiled
import           Heist.Compiled
import           Text.Digestive
import           Text.Digestive.Heist.Compiled
import           Text.Digestive.Snap
-------------------------------------------------------------------------------
import           Web.Application
import           Web.App.Common
import           Web.App.Forms



data ProfileForm = ProfileForm
  { pfLogin   :: Text
  , pfEmail   :: Text
  } deriving (Show)

data PasswordForm = PasswordForm
  { oldPass :: Text
  , pass1   :: Text
  , pass2   :: Text
  }

profileForm :: Maybe ProfileForm -> Form Text (Handler App App) ProfileForm
profileForm u = loginCheck $ ProfileForm
  <$> nonBlank ( "login" .: text (pfLogin <$> u))
  <*> nonBlank ( "email" .: text (pfEmail <$> u))

passwordForm :: Maybe PasswordForm -> Form Text (Handler App App) PasswordForm
passwordForm def = validatePasswordForm $ PasswordForm
  <$> "old_pass" .: text (oldPass <$> def)
  <*> "pass1" .: text (pass1 <$> def)
  <*> "pass2" .: text (pass2 <$> def)

profileFormName :: Text
profileFormName = "profile-form"

runProfileForm :: Handler App App (View Text, Maybe ProfileForm)
runProfileForm = do
    AuthUser{..} <- maybe pass return =<< with auth currentUser
    let pf = ProfileForm userLogin $ fromMaybe "" userEmail
    runForm profileFormName (profileForm $ Just pf)

profileFormSplice :: Splice (Handler App App)
profileFormSplice = formSplice mempty mempty (lift $ liftM fst runProfileForm)

passwordFormName :: Text
passwordFormName = "password-form"

runPasswordForm :: Handler App App (View Text, Maybe PasswordForm)
runPasswordForm = runForm passwordFormName (passwordForm Nothing)

passwordFormSplice :: Splice (Handler App App)
passwordFormSplice =
    formSplice mempty mempty (lift $ liftM fst runPasswordForm)

------------------------------------------------------------------------------
-- | 
loginCheck :: Form Text (Handler App App) ProfileForm
           -> Form Text (Handler App App) ProfileForm
loginCheck = checkM ("This username is in use by an existing user." :: Text) f
  where
    f ProfileForm{..} = do
      AuthUser{..} <- maybe pass return =<< with auth currentUser
      exist <- with auth $ withBackend (\r -> liftIO $ lookupByLogin r pfLogin)
      return $ isNothing exist || pfLogin == userLogin

validatePasswordForm :: Form Text (Handler App App) PasswordForm
                     -> Form Text (Handler App App) PasswordForm
validatePasswordForm = validateM $ \pf@PasswordForm{..} -> do
    let confirmCheck = if pass1 == pass2
                         then Success pf
                         else Error "Passwords do not match"
    mu <- with auth currentUser
    return $ case mu of
      Nothing -> Error "Not logged in"
      Just u -> maybe confirmCheck (\_ -> Error "Old password incorrect") $
                      authenticatePassword u $ ClearText $ T.encodeUtf8 oldPass

tDir :: ByteString -> ByteString
tDir = B.append "/profile/"

profileH :: Handler App App ()
profileH = do
  mu <- with auth currentUser
  case mu of
    Nothing -> pass
    Just _ -> render (tDir "show")

-------------------------------------------------------------------------------
editProfileH :: Handler App App ()
editProfileH = do
  u@AuthUser{..} <- maybe pass return =<< with auth currentUser
  (_,r) <- runProfileForm
  case r of
    Nothing -> render (tDir "edit")
    Just (ProfileForm login email) -> do
      with auth $ saveUser $ u { userLogin = login
                               , userEmail = Just email }
      flashInfo sess "Profile updated."
      redirToProfile

-------------------------------------------------------------------------------
passwordH :: Handler App App ()
passwordH = do
  mau <- with auth currentUser
  (_,r) <- runPasswordForm
  case r of
    Nothing -> render (tDir "changePassword")
    Just (PasswordForm _ pass1 _) -> do
      let bad = flashError sess "Not logged in"
          good au = do au' <- liftIO $ setPassword au (T.encodeUtf8 pass1)
                       with auth $ saveUser au'
                       flashInfo sess "Password changed."
      maybe bad good mau
      redirToProfile

redirToProfile :: MonadSnap m => m a
redirToProfile = redirect "/profile"

