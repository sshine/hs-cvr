
module CVR.Shared where

import Data.Text (Text)
import Data.Time.Clock (NominalDiffTime)

newtype Phone = Phone Text
  deriving (Eq, Ord, Show)

data Country
  = Denmark
  deriving (Eq, Ord, Show)

data Address = Address
  { addressStreet     :: Text
  , addressPostalCode :: Text
  , addressDistrict   :: Text
  , addressCountry    :: Country
  } deriving (Eq, Ord, Show)

data Timespan = Timespan
  { timespanStart :: Maybe NominalDiffTime
  , timespanEnd   :: Maybe NominalDiffTime
  } deriving (Eq, Ord, Show)

