{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RecordWildCards           #-}

module Web.App.Users
    ( usersR
    , addUsersR
    , usersRRoutes
    , userSplices
    , userRESTSplices
    , getUser
    , userEditFormSplice
    ) where


-------------------------------------------------------------------------------
import           Control.Applicative
import           Control.Error
import           Control.Monad.Reader
import           Data.ByteString                       (ByteString)
import qualified Data.ByteString as B
import           Data.Monoid
import           Data.Text             (Text)
import qualified Data.Text             as T
import           Data.Text.Encoding
import           Heist
import           Heist.Compiled
import           Snap
import           Snap.Extras.FormUtils
import           Snap.Extras.NavTrails
import           Snap.Restful
import           Snap.Snaplet.Auth
import           Snap.Snaplet.Auth.Backends.PostgresqlSimple()
import           Snap.Snaplet.Heist.Compiled
import           Snap.Snaplet.PostgresqlSimple
import           Text.Digestive
import           Text.Digestive.Heist.Compiled
import           Text.Digestive.Snap
-------------------------------------------------------------------------------
import           Web.Application
import           Web.App.Common
import           Web.App.Forms
-------------------------------------------------------------------------------


resourceName :: Text
resourceName = "users"

resourceUrl :: Text
resourceUrl = "/admin/users"

tDir :: ByteString -> ByteString
tDir n = B.concat [encodeUtf8 $ resourceUrl, "/", n]


userSplices :: Splices (Splice (Handler App App))
userSplices = do
    "userForm" #! userEditFormSplice
    "userListing" #! userListingSplice
    "userView" #! withSplices runChildren userRESTSplices $ lift getUser
    


-------------------------------------------------------------------------------
usersR :: Resource
usersR = Resource {
           rName = resourceName
         , rRoot = resourceUrl
         , rResourceEndpoints = map fst rResourceActions
         , rItemEndpoints = map fst rItemActions
         }

usersRRoutes :: [(ByteString, Handler App App ())]
usersRRoutes = resourceRoutes usersR rCrud rResourceActions rItemActions

addUsersR :: Snaplet (Heist App) -> Initializer App App ()
addUsersR = addResource usersR rCrud rResourceActions rItemActions

rCrud :: [(CRUD, Handler App App ())]
rCrud = [ (RNew, newH)
        , (RShow, showH)
        , (REdit, editH)
        , (RUpdate, updateH)
        , (RCreate, createH)
        , (RIndex, indexH) ]

rResourceActions :: [a]
rResourceActions = []

rItemActions :: [(Text, Handler App App ())]
rItemActions = [ ("suspend", usersSuspendH)
               , ("unSuspend", usersUnSuspendH) ]

                                --------------
                                -- Handlers --
                                --------------


-------------------------------------------------------------------------------
-- | Gets the user being operated on (probably only for admin actions).
getUser :: Handler App App AuthUser
getUser = do
  res <- runEitherT $ do
    k <- noteT "Must supply id" $ MaybeT $ getParam "id"
    noteT "Could not find user" $ MaybeT $ with auth $ withBackend
      (\r -> liftIO $ lookupByUserId r (UserId $ decodeUtf8 k))
  either badReq return res


-------------------------------------------------------------------------------
indexH :: Handler App App ()
indexH = render (tDir "index")


-------------------------------------------------------------------------------
newH :: Handler App App ()
newH = do
  setTitle "New User"
  render (tDir "new")


mkDBId :: Integer -> DBId
mkDBId i = DBId $ fromIntegral i


-------------------------------------------------------------------------------
createH :: Handler App App ()
createH = do
  setTitle "Create User"
  res <- runEitherT $ do
    UserForm{..} <- noteT (AuthError "Error in user form") $
      MaybeT $ fmap snd $ runForm "user-form" $ loginCheck $ userForm Nothing
    p <- noteT (AuthError "No password") $ MaybeT $ return ufPassword
    u <- EitherT $ with auth $ createUser ufLogin (encodeUtf8 p)
    EitherT $ with auth $ saveUser (u {userEmail = Just ufEmail})
  case res of
    Left authFailure -> do
      flashError sess (T.pack $ show authFailure)
      newH
    Right u -> do
      flashSuccess sess "New user created successfully."
      maybe newH (redirToItem usersR . mkDBId . read . T.unpack . unUid) $ userId u


-------------------------------------------------------------------------------
editH :: Handler App App ()
editH = do
    setTitle "Edit User"
    render (tDir "edit")


-------------------------------------------------------------------------------
showH :: Handler App App ()
showH = do
  with navTrail setFocus
  render (tDir "show")


-------------------------------------------------------------------------------
updateH :: Handler App App ()
updateH = do
  user <- getUser
  (_,r) <- runForm "user-form" $ userForm (Just user)
  case r of
    Nothing -> do
      flashError sess "Could not save user."
      editH
    Just UserForm{..} -> do
      p <- maybe (return $ userPassword user)
                 (liftIO . liftM Just . encryptPassword . ClearText . encodeUtf8)
                 ufPassword
      with auth $ saveUser $
          user { userLogin = ufLogin
               , userEmail = Just ufEmail
               , userPassword = p }
      maybe editH (redirToItem usersR . mkDBId . read . T.unpack . unUid) $ userId user


-------------------------------------------------------------------------------
usersSuspendH :: Handler App App b
usersSuspendH = do
  now <- getTime
  res <- runEitherT $ do
    k <- noteT "Must supply an id" $ MaybeT $ getParam "id"
    u <- noteT "Could not find user" $ MaybeT $ with auth $ withBackend
           (\r -> liftIO $ lookupByUserId r (UserId $ decodeUtf8 k))
    bimapEitherT show id $ EitherT $
      with auth $ saveUser (u { userSuspendedAt = Just now })
  case res of
    Left e -> flashError sess (T.pack e)
    Right _ -> flashSuccess sess "User restored from suspension."
  with navTrail $ redirFocus "/admin/users"


-------------------------------------------------------------------------------
usersUnSuspendH :: Handler App App b
usersUnSuspendH = do
  res <- runEitherT $ do
    k <- noteT "Must supply an id" $ MaybeT $ getParam "id"
    u <- noteT "Could not find user" $ MaybeT $ with auth $ withBackend
           (\r -> liftIO $ lookupByUserId r (UserId $ decodeUtf8 k))
    bimapEitherT show id $ EitherT $
      with auth $ saveUser (u { userSuspendedAt = Nothing })
  case res of
    Left e -> flashError sess (T.pack e)
    Right _ -> flashSuccess sess "User restored from suspension."
  with navTrail $ redirFocus "/admin/users"





                                 -------------
                                 -- Splices --
                                 -------------



-------------------------------------------------------------------------------
userListingSplice :: Splice (Handler b App)
userListingSplice =
  manyWithSplices runChildren userRESTSplices
                  (lift $ query_ "SELECT * FROM snap_auth_user")


userRESTSplices :: Monad n
                => Splices (RuntimeSplice n AuthUser -> Splice n)
userRESTSplices = do
  userCSplices
  mapS (pureSplice . textSplice) authPathSplices

authPathSplices :: Splices (AuthUser -> Text)
authPathSplices = mapS (. maybe (DBId (-1)) mkDBId . f) (itemCSplices usersR)
  where
    f = readMay . T.unpack . unUid <=< userId


                                  -----------
                                  -- Forms --
                                  -----------


-------------------------------------------------------------------------------
data UserForm p = UserForm {
      ufId       :: Maybe Int
    , ufLogin    :: Text
    , ufEmail    :: Text
    , ufPassword :: p
    } deriving (Show)


-------------------------------------------------------------------------------
userForm :: Maybe AuthUser
         -> Form Text (Handler App App) (UserForm (Maybe Text))
userForm u = validate passCheck $ UserForm
  <$> validate readMayTrans ("id" .: text (unUid <$> (userId =<< u)))
  <*> nonBlank ( "login" .: text (userLogin <$> u))
  <*> nonBlank ( "email" .: text (userEmail =<< u))
  <*> "pass" .: passFields


-------------------------------------------------------------------------------
passFields :: (Monad m, Monoid v) => Form v m (Text, Text)
passFields = ((,)
  <$> "pass" .: text Nothing
  <*> "pass_conf" .: text Nothing)


-------------------------------------------------------------------------------
passCheck :: UserForm (Text,Text) -> Result Text (UserForm (Maybe Text))
passCheck u@UserForm{..} =
  let (p,c) = ufPassword
  in case ufId of
    Just _ ->
      if T.null p && T.null c then
        Success $ u { ufPassword = Nothing }
      else if p /= c then
        Error matchErr
      else
        Success $ u { ufPassword = Just p }
    Nothing ->
      if T.null p || T.null c then
        Error blankErr
      else if p /= c then
        Error matchErr
      else
        Success $ u { ufPassword = Just p }
  where
    blankErr = "A password and its confirmation must be provided when creating a new user."
    matchErr = "The password does not match its confirmation."



-------------------------------------------------------------------------------
loginCheck :: Form Text (Handler b App) (UserForm t)
           -> Form Text (Handler b App) (UserForm t)
loginCheck = checkM ("This username is in use by an existing user." :: Text) f
    where
      f UserForm{..} = do
        exist <- with auth $ withBackend (\r -> liftIO $ lookupByLogin r ufLogin)
        return $ isNothing exist

runUserForm :: Maybe AuthUser
            -> Handler App App (View Text, Maybe (UserForm (Maybe Text)))
runUserForm def = runForm "user-form" (userForm def)

userFormSplice :: Handler App App (Maybe AuthUser)
               -> Splice (Handler App App)
userFormSplice m = formSplice mempty mempty $ lift $
    liftM fst $ runUserForm =<< m


userEditFormSplice :: Splice (Handler App App)
userEditFormSplice = do
    editFormSplice userFormSplice $ \key -> do
        with auth $ withBackend (\r -> liftIO $ lookupByUserId r (UserId $ decodeUtf8 key))



