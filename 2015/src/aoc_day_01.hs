{-- 
 Solutions for Day 1!

 Part 1: Follow parenthetical directions!
 Part 2: Find first position that puts us below ground!
 
 https://adventofcode.com/2015/day/1
--}

import Data.List (findIndex)

getInpt :: IO [Char]
getInpt = do readFile "../input/input_day_01.txt"

parenToDir :: Char -> Int
parenToDir '(' = 1
parenToDir ')' = -1

parseDirs :: [Char] -> [Int]
parseDirs = map parenToDir 

dirsToFloor :: [Char] -> Int
dirsToFloor parens = sum $ parseDirs parens

reachesBasement :: [Char] -> Maybe Int
reachesBasement parens = 
    let pos = scanl (+) 0 (parseDirs parens) in
    findIndex (< 0) pos

main = do
    inpt <- getInpt
    let solnPart1 = dirsToFloor inpt
    putStrLn $ "Solution to Day 1, Part 1: " ++ show solnPart1

    let solnPart2 = reachesBasement inpt   
    case solnPart2 of
        Nothing -> putStrLn $ "Solution to Day 1, Part 2: Never in basement!"
        Just x -> putStrLn $ "Solution to Day 1, Part 2: " ++ show x

