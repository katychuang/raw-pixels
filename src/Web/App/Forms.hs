{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}

module Web.App.Forms where

import           Data.String
import           Text.Digestive

nonBlank :: (Eq a, Monad m, Data.String.IsString a, Data.String.IsString v)
         => Form v m a -> Form v m a
nonBlank = check "Must be present." f
    where f "" = False
          f _ = True

