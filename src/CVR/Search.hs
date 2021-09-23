{-# LANGUAGE TemplateHaskell #-}

module CVR.Search where

import Data.Aeson
import Data.Maybe (fromJust)
import Data.Text (Text)
import Data.Text as Text
import Data.Text.Encoding as Text
import Data.ByteString (ByteString)
import Data.ByteString.Char8 as BS
import qualified Data.Vector as Vector
import Text.Heterocephalus
import Text.Blaze.Renderer.Utf8 as Blaze
import Control.Monad.IO.Class
import Network.HTTP.Req
import System.Environment as Env
import Control.Retry as Retry

data SearchQuery
  = NameSearch Text
--  | CvrNumberSearch CvrNumber
  deriving (Eq, Ord, Show)

-- FIXME: JSON Escape queryString
nameSearchTemplate :: Text -> Value
nameSearchTemplate queryString =
  fromJust (decode (Blaze.renderMarkup $(compileTextFile "templates/nameSearchTemplate.json.tmpl")))

--cvrNumberSearchTemplate :: CvrNumber -> Value

instance ToJSON SearchQuery where
  toJSON (NameSearch queryString) =
    nameSearchTemplate queryString

-- curl -v -u "$CVR_USER:$CVR_PASS" -H "Content-Type: application/json" -XPOST "$URL" -d"$QUERY"

searchReq :: SearchQuery -> IO ()
searchReq searchQuery = do
  cvrHost <- Text.pack <$> Env.getEnv "CVR_HOST"
  cvrUser <- BS.pack <$> Env.getEnv "CVR_USER"
  cvrPass <- BS.pack <$> Env.getEnv "CVR_PASS"
  runReq tmpHttpConfig $ do
    let payload = toJSON searchQuery
    r <- req POST (http cvrHost /: "cvr-permanent/virksomhed/_search")
                  (ReqBodyJson payload)
                  jsonResponse -- bsResponse
                  (basicAuthUnsafe cvrUser cvrPass)

    liftIO $ print (responseBody r :: Value)
    -- liftIO $ print (responseBody r :: ByteString)
  where
    tmpHttpConfig = defaultHttpConfig
      { httpConfigRetryPolicy = tmpRetryPolicy
      }

tmpRetryPolicy :: (Monad m) => RetryPolicyM m
tmpRetryPolicy = Retry.constantDelay 50 <> Retry.limitRetries 1

mappingReq :: IO ()
mappingReq = do
  cvrHost <- Text.pack <$> Env.getEnv "CVR_HOST"
  cvrUser <- BS.pack <$> Env.getEnv "CVR_USER"
  cvrPass <- BS.pack <$> Env.getEnv "CVR_PASS"
  runReq defaultHttpConfig $ do
    r <- req GET (http cvrHost /: "cvr-permanent")
                 NoReqBody
                 jsonResponse
                 (basicAuthUnsafe cvrUser cvrPass)
    liftIO $ print (responseBody r :: Value)
