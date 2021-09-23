
module EventSourcing where

-- Event Sourcing
--
-- Scan the CVR Vrvirksomhed structure and produce events.
--
-- An event is something that is true about a certain pre-defined property, at a given time.
--
-- The properties belong to the problem domain (e.g. company name, company owner, etc.).
--
-- The time at which something is true is either a point, or a (possibly open) interval.

data Knowledge property = Knowledge
  { knowledgeProperty :: property
  , knowledgeTime :: KnowledgeTime
  } deriving (Eq, Ord, Show)

data KnowledgeTime
  = Point Time
  | Interval (Maybe NominalDiffTime) (Maybe NominalDiffTime)
