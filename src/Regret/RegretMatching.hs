module Regret.RegretMatching
    ( RMProgress(..)
    , newRMProgress
    , extractStrategies
    , iterateRM
    , trainRM
    ) where

import Data.Array
import System.Random

import Regret.Game
import Regret.ExampleGames (Throw, rps)


data RMProgress a b
    = RMProgress
    { stratProfSumA :: Array a Double
    , stratProfSumB :: Array b Double
    , cumRegretA :: Array a Int
    , cumRegretB :: Array b Int
    }

newRMProgress :: (Ix a, Ix b) => Game a b -> RMProgress a b
newRMProgress (Game boundsA boundsB _ _) =
    let a = listArray boundsA $ repeat 0
        b = listArray boundsB $ repeat 0
        a' = listArray boundsA $ repeat 0
        b' = listArray boundsB $ repeat 0
    in RMProgress a b a' b'

extractStrategies :: (Ix a, Ix b) => RMProgress a b -> ([(a, Double)], [(b, Double)])
extractStrategies (RMProgress a b _ _) =
    let sumA = sum $ elems a
        sumB = sum $ elems b
    in ( assocs $ fmap (/ sumA) a
       , assocs $ fmap (/ sumB) b
       )
       
stratProfile :: Ix i => Array i Int -> ([(i, Int)], Int)
stratProfile arr =
    let positives = filter ((>0) . snd) $ assocs arr
    in if length positives == 0 then
           ([(i, 1) | i <- indices arr], length $ indices arr) else
           (positives, sum $ fmap snd positives)

normalize :: [(a, Int)] -> [(a, Double)]
normalize ps =
    let q = fromIntegral $ sum $ fmap snd ps
    in fmap (\(a, i) -> (a, fromIntegral i / q)) ps

randomChoice :: [(a, Int)] -> Int -> a
randomChoice ((a, n):ps) total
    | total - n <= 0 = a
    | otherwise = randomChoice ps $ total - n

iterateRM :: (Ix a, Ix b) => Game a b -> RMProgress a b -> IO (RMProgress a b)
iterateRM (Game boundsA boundsB f g) (RMProgress sumA sumB cumA cumB) = do
    let (profileListA, countA) = stratProfile cumA
        (profileListB, countB) = stratProfile cumB
        sumA' = accum (+) sumA $ normalize profileListA
        sumB' = accum (+) sumB $ normalize profileListB
    rnd1 <- getStdRandom next
    rnd2 <- getStdRandom next
    let actionA = randomChoice profileListA $ 1 + (rnd1 `mod` countA)
        actionB = randomChoice profileListB $ 1 + (rnd2 `mod` countB)
        cumA' = accum (+) cumA
                    [ (i, f i actionB - f actionA actionB)
                    | i <- indices cumA
                    ]
        cumB' = accum (+) cumB
                    [ (i, g actionA i - g actionA actionB)
                    | i <- indices cumB
                    ]
    return $ RMProgress sumA' sumB' cumA' cumB'

iterateHelper :: Monad m => (a -> m a) -> Int -> a -> m a
iterateHelper f n a
    | n <= 0 = return a
    | otherwise = do {a' <- f a; iterateHelper f (n-1) a'}

trainRM :: (Ix a, Ix b) => Game a b -> Int -> IO ([(a, Double)], [(b, Double)])
trainRM g n = do
    let first = newRMProgress g
    rmp <- iterateHelper (iterateRM g) n first
    return $ extractStrategies rmp
