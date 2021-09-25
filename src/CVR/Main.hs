{-# LANGUAGE OverloadedStrings #-}

module CVR.Main where

import Control.Monad.Reader (ReaderT(..), liftIO)

import CVR (CVR)
import CVR.Company
import CVR.Config (loadConfig)
import CVR.Search (cvrSearchReq, SearchQuery(..))

main :: IO ()
main = loadConfig >>= runReaderT app

app :: CVR ()
app = do
  -- result <- cvrSearchReq (CompanyNumberSearch (CompanyNumber CvrNumber 41834226))
  result <- cvrSearchReq (CompanyNameSearch "Shine Holding")
  liftIO (print result)
