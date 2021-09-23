
module EventSourcing where

import Data.Text (Text)
import Data.Time.Clock (NominalDiffTime)

data Knowledge property = Knowledge
  { knowledgeProperty :: property
  , knowledgeTime :: KnowledgeTime
  }

--deriving instance Eq property => Eq (Knowledge property)
--deriving instance Ord property => Ord (Knowledge property)
deriving instance Show property => Show (Knowledge property)

data KnowledgeTime
  = Interval (Maybe NominalDiffTime) (Maybe NominalDiffTime)
  deriving (Eq, Ord, Show)

-- Event Sourcing
--
-- Scan the CVR Vrvirksomhed structure and produce events.
--
-- An event is something that is true about a certain pre-defined property, at a given time.
--
-- The properties belong to the problem domain (e.g. company name, company owner, etc.).
--
-- The time at which something is true is either a point, or a (possibly open) interval.


