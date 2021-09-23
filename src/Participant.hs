
module Participant where

import Data.Text (Text)
import Data.Time.Clock (NominalDiffTime)

import Shared

data Participant f = Participant
  { participantType    :: f ParticipantType
  , participantName    :: f Text
  , participantAddress :: f Address
  }

data ParticipantType
  = PersonParticipant
  | CompanyParticipant
  deriving (Eq, Ord, Show)
