{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module CVR.Search where

import Control.Monad.Reader (reader, liftIO)

import Data.Maybe (fromJust)
import Data.Text (Text)
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import qualified Data.ByteString.Lazy as LBS
import qualified Data.ByteString.Char8 as BS

import Data.Aeson
import Text.Heterocephalus
import Network.HTTP.Req

import qualified Text.Blaze as Blaze
import qualified Text.Blaze.Renderer.Utf8 as Blaze
import qualified System.Environment as Env

import CVR (CVR)
import CVR.Config (Config(..))
import CVR.Company

data SearchQuery
  = CompanyNameSearch Text
  | CompanyNumberSearch CompanyNumber
  deriving (Eq, Ord, Show)

companyNameSearch :: Text -> Value
companyNameSearch queryStringUnsafe =
  -- FIXME: This is so ugly there has to be a better way.
  let queryString = Text.decodeUtf8 (LBS.toStrict (encode (String queryStringUnsafe)))
  in renderTemplate $(compileTextFile "templates/companyNameSearch.tmpl.json")

-- TODO: Cover missing CompanyNumber types
companyNumberSearch :: CompanyNumber -> Value
companyNumberSearch (CompanyNumber CvrNumber cvrNumber) =
  renderTemplate $(compileTextFile "templates/companyNumberSearch.tmpl.json")

renderTemplate :: Blaze.Markup -> Value
renderTemplate = fromJust . decode . Blaze.renderMarkup

instance ToJSON SearchQuery where
  toJSON (CompanyNameSearch queryString) =
    companyNameSearch queryString

  toJSON (CompanyNumberSearch companyNumber) =
    companyNumberSearch companyNumber

-- curl -v -u "$CVR_USER:$CVR_PASS" -H "Content-Type: application/json" -XPOST "$URL" -d"$QUERY"
cvrSearchReq :: SearchQuery -> CVR Value
cvrSearchReq searchQuery =
  cvrPostReq "cvr-permanent/virksomhed/_search" searchQuery

cvrPostReq :: ToJSON body => Text -> body -> CVR Value
cvrPostReq url body = do
  cvrHost <- reader configCvrHost
  cvrUser <- reader configCvrUser
  cvrPass <- reader configCvrPass
  runReq defaultHttpConfig $ do
    let auth = basicAuthUnsafe cvrUser cvrPass
        endpoint = http cvrHost /: url
        payload = toJSON body
    responseBody <$> req POST endpoint (ReqBodyJson payload) jsonResponse auth

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
