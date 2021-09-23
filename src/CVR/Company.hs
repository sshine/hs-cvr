
module CVR.Company where

import Data.Text (Text)
import Data.Time.Clock (NominalDiffTime)

import CVR.Shared
import CVR.Participant
import CVR.ParticipantRelation

data Company f = Company
  { companyName                :: f Text
  , companyNumber              :: f CompanyNumber
  , companyAddress             :: f Address
  , companyPhone               :: f Phone
  , companyLifetime            :: f Timespan
  , companyIndustry            :: f Industry
  , companyStatus              :: f CompanyStatus
  , companyType                :: f CompanyType
-- TODO: Each p-enhed has person members
  , companyParticipantRelation :: f [ParticipantRelation f]
  }

data CompanyNumber = CompanyNumber
  { companyNumberType  :: CompanyNumberType
  , companyNumberValue :: Integer
  } deriving (Eq, Ord, Show)

data CompanyNumberType
  = CvrNumber
  | RegNumber
  | PNumber
  | SENumber
  | UnitNumber -- enhedsnummer
  deriving (Eq, Ord, Show)

data Industry = Industry
  { industryCode :: Integer
  , industryText :: Text
  } deriving (Eq, Ord, Show)

data CompanyStatus
  = Normal
  deriving (Eq, Ord, Show)

data CompanyType = CompanyType
  { companyTypeCountry :: Country
  , companyTypeGeneric :: GenericCompanyType
  } deriving (Eq, Ord, Show)

data GenericCompanyType
  = LimitedCompany
  deriving (Eq, Ord, Show)
