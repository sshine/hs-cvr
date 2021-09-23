
module CVR.ParticipantRelation where

import Data.Text (Text)
import Data.Time.Clock (NominalDiffTime)

import CVR.Shared
import CVR.Participant

data ParticipantRelation f = ParticipantRelation
  { participantEntity  :: f (Participant f)
  , participantRole    :: f ParticipantRole
  , participantAddress :: f Address
  }

data ParticipantRole
  = BoardMember
  deriving (Eq, Ord, Show)

