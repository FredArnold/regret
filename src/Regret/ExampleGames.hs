module Regret.ExampleGames
    ( rps
    , blotto
    , blottoStratRepr
    ) where

import Data.Array

import Regret.Game
    

rps :: Game Int Int
rps = ZSGame (1, 3) (1, 3) rpsPayout

rpsPayout :: Int -> Int -> Int
rpsPayout x y
    | x == y = 0
    | x == y+1 = 1
    | x == 1 && y == 3 = 1
    | otherwise = -1

rpsRepr :: Int -> String
rpsRepr 1 = "Rock"
rpsRepr 2 = "Paper"
rpsRepr 3 = "Scissors"

blotto :: Game Int Int
blotto = ZSGame (0, 4) (0, 4) blottoPayout

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
