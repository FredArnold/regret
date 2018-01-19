module Regret.Game
    ( Game(..)
    ) where


-- Integral statt Double!
data Game a b
    = ZSGame
    { stratBoundsA :: (a, a)
    , stratBoundsB :: (b, b)
    , payouts :: a -> b -> Int
    }
