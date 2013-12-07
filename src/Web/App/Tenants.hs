{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RecordWildCards           #-}
{-# LANGUAGE ScopedTypeVariables       #-}
{-# LANGUAGE TupleSections             #-}


module Web.App.Tenants
    ( tenantsR
    , addTenantsR
    , tenantSplices
    , tenantFormSplice
    , tenantEditFormSplice
    ) where

-------------------------------------------------------------------------------
import           Data.ByteString        (ByteString)
import qualified Data.ByteString        as B
import           Data.Text              (Text)
import qualified Data.Text              as T
import           Snap
import           Snap.Extras.FormUtils
import           Snap.Restful
import           Snap.Snaplet.Heist.Compiled
import           Heist.Compiled
import           Text.Digestive.Form
import           Text.Digestive.Heist.Compiled
import           Text.Digestive.Snap hiding (method)
import           Text.Digestive.View
-------------------------------------------------------------------------------
import           Web.Application
import           Web.App.Common


data Tenant = Tenant
    { tenantName      :: Text
    , tenantSubdomain :: Text
    , tenantActive    :: Bool
    }


-------------------------------------------------------------------------------
tenantsR :: Resource
tenantsR = Resource {
           rName = "tenants"
         , rRoot = "/admin/tenants"
         , rResourceEndpoints = map fst rResourceActions
         , rItemEndpoints = map fst rItemActions
         }

addTenantsR :: Snaplet (Heist App) -> Initializer App App ()
addTenantsR = addResource tenantsR rCrud rResourceActions rItemActions

rCrud :: [(CRUD, Handler App App ())]
rCrud = [ (RIndex, indexH)
        , (RCreate, method POST createH)
        , (RUpdate, method POST updateH)
        , (REdit, editH)
        , (RNew, newH)
        , (RShow, showH) ]

rResourceActions :: [a]
rResourceActions = []

rItemActions :: [a]
rItemActions = []


tDir :: ByteString -> ByteString
tDir n = B.append "/admin/tenants/" n


tenantSplices :: [(Text, Splice (Handler b App))]
tenantSplices =
    [ ("tenantForm", tenantEditFormSplice)
    , ("tenantListing", tenantListingSplice)
    , ("tenantView", withSplices runChildren entitySplices $ lift getRecord)
    ] 


                                --------------
                                -- Handlers --
                                --------------


-------------------------------------------------------------------------------
getRecord :: Handler b App (Entity Tenant)
getRecord = do
  k <- mkKeyBS `fmap` reqParam "id"
  maybeBadReq "Tenant does not exist." $
    runPersist' $ selectFirst [TenantId ==. k] []


-------------------------------------------------------------------------------
indexH :: HasHeist b => Handler b v ()
indexH = render (tDir "index")


-------------------------------------------------------------------------------
newH :: HasHeist b => Handler b v ()
newH = render (tDir "new")


-------------------------------------------------------------------------------
editH :: HasHeist b => Handler b v ()
editH = render (tDir "edit")


-------------------------------------------------------------------------------
showH :: HasHeist b => Handler b v ()
showH = render (tDir "show")


-------------------------------------------------------------------------------
createH :: Handler App App ()
createH = do
  (_,r) <- runForm tenantFormName $ tenantForm Nothing
  case r of
    Nothing -> do
      flashError sess "Can't save Entity definition."
      newH
    Just TenantForm{..} -> do
      cid <- loggedInsert $
             Tenant tfName tfSubdomain tfActive
      flashSuccess sess "Created new Entity definition."
      redirToItem tenantsR (mkDBId cid)


-------------------------------------------------------------------------------
updateH :: Handler App App ()
updateH = do
  (Entity k tenant) <- getRecord
  (_,r) <- runForm tenantFormName $ tenantForm (Just $ mkForm tenant)
  case r of
    Nothing -> do
      flashError sess "Can't save Entity definition."
      editH
    Just TenantForm{..} -> do
      loggedUpdate k
        [ TenantName =. tfName
        , TenantSubdomain =. tfSubdomain
        , TenantActive =. tfActive
        ]
      flashSuccess sess "Entity definition has been updated."
      redirToItem tenantsR (mkDBId k)



                                 -------------
                                 -- Splices --
                                 -------------


-------------------------------------------------------------------------------
tenantListingSplice :: Splice (Handler b App)
tenantListingSplice =
    manyWithSplices runChildren entitySplices
      (lift $ runPersist' $ selectList [] [])


-------------------------------------------------------------------------------
entitySplices :: Monad m
              => Splices (RuntimeSplice m (Entity Tenant) -> Splice m)
entitySplices = mapS (pureSplice . textSplice) $ do
    mapS (. mkDBId . entityKey) (itemCSplices tenantsR)
    "tenantId" #! showKey . entityKey)
    "tenantName" #! tenantName . entityVal)
    "tenantSubdomain" #! tenantSubdomain . entityVal)
    "tenantActive" #! yesNoBool . tenantActive . entityVal)

                                  -----------
                                  -- Forms --
                                  -----------



mkForm :: TenantGeneric backend -> TenantForm
mkForm t = TenantForm (tenantName t) (tenantSubdomain t) (tenantActive t)

-------------------------------------------------------------------------------
data TenantForm = TenantForm {
      tfName      :: Text
    , tfSubdomain :: Text
    , tfActive    :: Bool
    } deriving (Show)


-------------------------------------------------------------------------------
tenantForm :: (Monad m)
           => Maybe TenantForm
           -> Form Text m TenantForm
tenantForm def = TenantForm
  <$> "name" .: nameCheck (text (tfName <$> def))
  <*> "subdomain" .: text (tfSubdomain <$> def)
  <*> "active" .: bool (tfActive <$> def)
  where
    nameCheck = check "tenant name cannot be empty" (not . T.null)


tenantFormName :: Text
tenantFormName = "tenant-form"


-------------------------------------------------------------------------------
runTenantForm :: MonadSnap m
              => Maybe TenantForm
              -> m (View Text, Maybe TenantForm)
runTenantForm def = runForm tenantFormName (tenantForm def)


-------------------------------------------------------------------------------
tenantFormSplice :: MonadSnap m => m (Maybe TenantForm) -> Splice m
tenantFormSplice getter = formSplice [] [] $ lift $
    liftM fst $ runTenantForm =<< getter


-------------------------------------------------------------------------------
tenantEditFormSplice :: Splice (Handler b App)
tenantEditFormSplice = do
    editFormSplice tenantFormSplice $ \key -> do
        res <- runPersist' $ selectFirst [TenantId ==. mkKeyBS key] []
        return $ fmap (mkForm . entityVal) res

