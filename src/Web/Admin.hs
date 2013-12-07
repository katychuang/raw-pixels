{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE RecordWildCards           #-}

module Web.Admin where

import           Control.Monad.Trans.Maybe
import           Data.Text.Encoding
import           Snap
import           Snap.Snaplet.Auth


createUserH :: Handler b (AuthManager b) ()
createUserH = do
    res <- runMaybeT $ do
        u <- MaybeT $ getParam "username"
        p <- MaybeT $ getParam "password"
        lift $ createUser (decodeUtf8 u) p
    maybe (writeText "User not created")
          (const $ writeText "User created") res

