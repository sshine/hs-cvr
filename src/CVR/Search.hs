{-# LANGUAGE TemplateHaskell #-}

module CVR.Search where

import Data.Aeson
import Data.Maybe (fromJust)
import Data.Text (Text)
import Data.Text.Encoding as Text
import Data.ByteString (ByteString)
import qualified Data.Vector as Vector
import Text.Heterocephalus
import Text.Blaze.Renderer.Utf8 as Blaze
import Control.Monad.IO.Class
import Network.HTTP.Req
import System.Environment as Env

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
  cvrUser <- Env.getEnv "CVR_USER"
  cvrPass <- Env.getEnv "CVR_PASS"
  runReq defaultHttpConfig $ do
    let payload = toJSON searchQuery
    r <- req POST (https "distribution.virk.dk" :/ "/cvr-permanent/virksomhed/_search")
                  (ReqBodyJson payload)
                  jsonResponse
                  (basicAuth cvrUser cvrPass)

    liftIO $ print (responseBody r :: Value)
