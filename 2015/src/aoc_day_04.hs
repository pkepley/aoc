{-- 
 Solutions for Day 04!

 Part 1: Mine some AdventCoins.
 Part 2: Mine an AdventCoin fork.
 
 https://adventofcode.com/2015/day/04
--}

import Data.ByteString.Char8 (pack, unpack) 
import Data.ByteString.Base16 (encode)        -- base16-bytestring
import Crypto.Hash.MD5 (hash)                 -- cryptohash-md5

getInpt :: IO [Char]
getInpt = do readFile "../input/input_day_04.txt"

getHash :: String -> [Char]
getHash = unpack . encode . hash . pack

mineAdventCoin :: [Char] -> Int -> Int -> Int
mineAdventCoin secretKey nZeros index
    | (take nZeros acHash) == (replicate nZeros '0') = index
    | otherwise = mineAdventCoin secretKey nZeros (index + 1)
    where acHash = getHash (secretKey ++ show index)

solvePart1 :: [Char] -> Int
solvePart1 secretKey = mineAdventCoin secretKey 5 1

solvePart2 :: [Char] -> Int
solvePart2 secretKey = mineAdventCoin secretKey 6 1

main = do
    -- Had some issue with newlines, filtering for now to remove them.
    -- Input should only contain lowercase letters or numbers.
    inptTmp <- getInpt
    let inpt = filter (\x -> x `elem` ['a'..'z'] ++ ['0'..'9']) inptTmp

    let solnPart1 = solvePart1 inpt
    putStrLn $ "Solution to Day 4, Part 1: " ++ show solnPart1

    let solnPart2 = solvePart2 inpt
    putStrLn $ "Solution to Day 4, Part 2: " ++ show solnPart2
