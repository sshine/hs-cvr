
module CVR where

import Control.Monad.Reader (ReaderT)

import CVR.Config (Config)

-- | The base environment to perform CVR lookups
type CVR = ReaderT Config IO
