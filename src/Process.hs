
module Process where

import Data.Aeson
import Data.Aeson.Types
import Data.Maybe (fromMaybe)
import Data.Vector (Vector)
import qualified Data.Vector as Vector

import Shared
import Company
import EventSourcing

shineSearch :: FilePath
shineSearch = "data/navnesogning.json"

--process :: FilePath -> IO Knowledge CompanyNumber
process filePath = do
  obj <- decodeFileStrict filePath
  pure (fmap extractCVRNumber obj)

-- This is cvr-v-20200115
--
-- .hits.hits[]._source.Vrvirksomhed.cvrNummer

--extractCVRNumber :: Object -> Maybe (Vector (Knowledge CompanyNumber))
--extractCVRNumber :: Object -> Either ParseError Number
--extractCVRNumber result = [jq| .hits.hits[]._source.Vrvirksomhed.cvrNummer |]
extractCVRNumber :: Object -> Vector CompanyNumber
extractCVRNumber result =
  fromMaybe Vector.empty $
  flip parseMaybe result $ \obj -> do
    hits <- obj .: "hits"
    hitsArr <- hits .: "hits"
    flip traverse hitsArr $ \hit -> do
      source <- hit .: "_source"
      vrvirksomhed <- source .: "Vrvirksomhed"
      cvrNummer <- vrvirksomhed .: "cvrNummer"
      pure (CompanyNumber CvrNumber cvrNummer)
