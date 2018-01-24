module Regret.MaxRegretSelfplay
    ( iterateMaxRegret
    , trainMaxRegret
    , evalMaxRegretWithRPS
    , evalRegretMatchingWithRPS
    ) where

import Data.Array
import Data.List (sortOn)
    
import Regret.Game
import Regret.ExampleGames
import Regret.RegretMatching


iterateMaxRegret :: (Ix a, Ix b) => Game a b -> RMProgress a b -> RMProgress a b
iterateMaxRegret (Game boundsA boundsB f g) (RMProgress sumA sumB cumA cumB) = do
    let actionA = fst $ head $ sortOn ((*(-1)) . snd) $ assocs cumA
        actionB = fst $ head $ sortOn ((*(-1)) . snd) $ assocs cumB
        sumA' = accum (+) sumA [(actionA, 1)]
        sumB' = accum (+) sumB [(actionB, 1)]
        cumA' = accum (+) cumA
                    [ (i, f i actionB - f actionA actionB)
                    | i <- indices cumA
                    ]
        cumB' = accum (+) cumB
                    [ (i, g actionA i - g actionA actionB)
                    | i <- indices cumB
                    ]
    RMProgress sumA' sumB' cumA' cumB'

nestHelper :: Int -> (a -> a) -> a -> a
nestHelper n f
    | n <= 0 = id
    | otherwise = f . nestHelper (n-1) f

extractRPSError :: [(a, Double)] -> Double
extractRPSError =
    maximum . map (abs . ((1/3) -) . snd)
                  
trainMaxRegret :: (Ix a, Ix b) => Game a b -> Int -> ([(a, Double)], [(b, Double)])
trainMaxRegret g n =
    extractStrategies $ nestHelper n (iterateMaxRegret g) $ newRMProgress g

evalMaxRegretWithRPS :: Int -> Double
evalMaxRegretWithRPS n =
    let (l1, l2) = trainMaxRegret rps n
    in max (extractRPSError l1) (extractRPSError l2)

evalRegretMatchingWithRPS :: Int -> IO Double
evalRegretMatchingWithRPS n = do
    (l1, l2) <- trainRM rps n
    return $ max (extractRPSError l1) (extractRPSError l2)
