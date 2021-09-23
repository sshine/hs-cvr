{-# LANGUAGE RecordWildCards #-}

module CVR.Config where

import Data.Text (Text)
import qualified Data.Text as Text
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BS
import System.Environment as Env

data Config = Config
  { configCvrHost :: Text
  , configCvrUser :: ByteString
  , configCvrPass :: ByteString
  } deriving (Eq, Ord, Show)

loadConfig :: IO Config
loadConfig = do
  configCvrHost <- Text.pack <$> Env.getEnv "CVR_HOST"
  configCvrUser <- BS.pack <$> Env.getEnv "CVR_USER"
  configCvrPass <- BS.pack <$> Env.getEnv "CVR_PASS"
  pure Config {..}
