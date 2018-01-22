module Regret.Game
    ( Game(..)
    , zeroSumGame
    ) where


-- Integral statt Double!
data Game a b
    = Game
    { stratBoundsAnyA :: (a, a)
    , stratBoundsAnyB :: (b, b)
    , payoutFuncA :: a -> b -> Int
    , payoutFuncB :: a -> b -> Int
    }

zeroSumGame :: (a, a) -> (b, b) -> (a -> b -> Int) -> Game a b
zeroSumGame p1 p2 f =
    Game p1 p2 f (\x y -> (-1) * f x y)
