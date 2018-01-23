module Regret.ExampleGames
    ( Throw(..)
    , rps
    , sharperScissors
    , blotto
    , blottoStratRepr
    , Activity(..)
    , battleOfSexes
    ) where

import Data.Array

import Regret.Game
    

data Throw
    = Rock
    | Paper
    | Scissors
      deriving (Eq, Ord, Ix, Show)

rps :: Game Throw Throw
rps =
    zeroSumGame (Rock, Scissors) (Rock, Scissors) rpsPay

sharperScissors :: Game Throw Throw
sharperScissors =
    zeroSumGame (Rock, Scissors) (Rock, Scissors) $ \x y ->
        case (x, y) of
          (Scissors, Paper) -> 2
          (Paper, Scissors) -> -2
          (t1, t2) -> rpsPay t1 t2

rpsPay :: Throw -> Throw -> Int
rpsPay x y
    | x == y = 0
    | otherwise =
        case (x, y) of
          (Paper, Rock) -> 1
          (Scissors, Paper) -> 1
          (Rock, Scissors) -> 1
          _ -> -1

blotto :: Game Int Int
blotto = zeroSumGame (0, 4) (0, 4) blottoPayout

blottoPayout :: Int -> Int -> Int
blottoPayout x y =
    blottoArr ! (x, y)

blottoArr :: Array (Int, Int) Int
blottoArr =
    array ((0, 0), (4, 4))
          [ (i, blottoMatchup i)
          | i <- range ((0, 0), (4, 4))
          ]

blottoMatchup :: (Int, Int) -> Int
blottoMatchup (a, b) = sum $
    [blottoEval x y
    | x <- perm3 $ blottoStratRepr !! a
    , y <- perm3 $ blottoStratRepr !! b
    ]

perm3 :: (a, a, a) -> [(a, a, a)]
perm3 (a, b, c) =
    [ (a, b, c)
    , (a, c, b)
    , (b, a, c)
    , (b, c, a)
    , (c, a, b)
    , (c, b, a)
    ]

blottoEval :: (Int, Int, Int) -> (Int, Int, Int) -> Int
blottoEval (a, b, c) (x, y, z)
    | a > x && b > y = 1
    | a > x && c > z = 1
    | b > y && c > z = 1
    | a < x && b < y = -1
    | a < x && c < z = -1
    | b < y && c < z = -1
    | otherwise = 0

blottoStratRepr :: [(Int, Int, Int)]
blottoStratRepr =
    [ (5, 0, 0)
    , (4, 1, 0)
    , (3, 2, 0)
    , (3, 1, 1)
    , (2, 2, 1)
    ]

data Activity
    = Opera
    | Football
      deriving (Eq, Ord, Ix, Show)

battleOfSexes :: Game Activity Activity
battleOfSexes =
    Game (Opera, Football) (Opera, Football) f g
    where f = \x y -> case (x, y) of
                        (Opera, Opera) -> 3
                        (Opera, Football) -> 1
                        (Football, Opera) -> 0
                        (Football, Football) -> 2
          g = \x y -> case (x, y) of
                        (Opera, Opera) -> 2
                        (Opera, Football) -> 1
                        (Football, Opera) -> 0
                        (Football, Football) -> 3
