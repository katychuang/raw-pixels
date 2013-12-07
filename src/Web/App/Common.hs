{-# OPTIONS -fno-warn-orphans #-}
{-# LANGUAGE CPP                       #-}
{-# LANGUAGE FlexibleInstances         #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings         #-}
{-# LANGUAGE TemplateHaskell           #-}

module Web.App.Common
    ( module Web.App.Common
    , module Snap.Extras.TextUtils
    , module Snap.Extras.FlashNotice
    , module Snap.Extras.CoreUtils
    , module Snap.Extras.JSON
    , module Safe
    ) where

-------------------------------------------------------------------------------
import           Control.Error
import           Control.Lens
import           Data.Aeson                 as A
import           Data.ByteString            (ByteString)
import qualified Data.ByteString.Char8      as B
import qualified Data.ByteString.Lazy.Char8 as LB
import           Data.Char                  (isSpace)
import qualified Data.Map                   as M
import qualified Data.Sequence              as Seq
import           Data.String
import           Data.Text                  (Text)
import qualified Data.Text                  as T
--import           Data.Time
import           Safe
import           Snap.Extras.CoreUtils
import           Snap.Extras.FlashNotice
import           Snap.Extras.JSON
import           Snap.Extras.TextUtils
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
for :: [a] -> (a -> b) -> [b]
for = flip map


-------------------------------------------------------------------------------
collect :: (Ord k, Traversable t)
        => (a -> k)
        -- ^ key in collected map
        -> (a -> v)
        -- ^ value in collected map
        -> (v -> v -> v)
        -- ^ collapse function for value
        -> t a
        -- ^ something I can traverse, e.g. [a]
        -> M.Map k v
collect k v f as = foldrOf folded step M.empty as
    where
      step a r = M.insertWith' f (k a) (v a) r


-------------------------------------------------------------------------------
truncateT :: Int -> Text -> Text
truncateT i t =
  case T.length t > i of
    True -> T.concat [T.take i t, ".."]
    False -> t


------------------------------------------------------------------------------
-- | Lazy 'marshallJSON'
marshallJSON' :: ToJSON a => a -> LB.ByteString
marshallJSON' = A.encode


------------------------------------------------------------------------------
-- | Encode JSON
marshallJSON :: ToJSON a => a -> ByteString
marshallJSON = B.concat . LB.toChunks . A.encode


------------------------------------------------------------------------------
-- | Lazy 'unMarshallJSON'
unMarshallJSON' :: FromJSON a => LB.ByteString -> Maybe a
unMarshallJSON' = A.decode


------------------------------------------------------------------------------
-- | Decode JSON
unMarshallJSON :: FromJSON a => ByteString -> Maybe a
unMarshallJSON = A.decode . LB.fromChunks . return


-------------------------------------------------------------------------------
tsFormat :: String
tsFormat = "%Y-%m-%d-%H-%M-%S%Q-%Z"


-------------------------------------------------------------------------------
showBSL :: (Show a) => a -> LB.ByteString
showBSL x = LB.pack . show $ x


-------------------------------------------------------------------------------
showLBS :: Show a => a -> LB.ByteString
showLBS = showBSL


-------------------------------------------------------------------------------
readLBS :: Read a => LB.ByteString -> a
readLBS = readNote  "readLBS failed" . LB.unpack


-------------------------------------------------------------------------------
seqLast :: Seq.Seq a -> a
seqLast s = Seq.index s (Seq.length s - 1)


-------------------------------------------------------------------------------
stripBS :: ByteString -> ByteString
stripBS = B.reverse . B.dropWhile isSpace . B.reverse . B.dropWhile isSpace


-------------------------------------------------------------------------------
eitherMaybe :: Either t a -> Maybe a
eitherMaybe (Left _) = Nothing
eitherMaybe (Right x) = Just x


-------------------------------------------------------------------------------
readMayT :: Read a => Text -> Maybe a
readMayT = readMay . T.unpack


-------------------------------------------------------------------------------
yesNoBool :: IsString a => Bool -> a
yesNoBool True = "Yes"
yesNoBool False = "No"


