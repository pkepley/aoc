{-- 
 Solutions for Day 3!

 Part 1: Count houses Santa visits at least once!
 Part 2: Count houses Santa and Robot visit at least once!
 
 https://adventofcode.com/2015/day/3
--}

import Data.List (nub)

getInpt :: IO [Char]
getInpt = do readFile "../input/input_day_03.txt"

dirToVec '^' = (0,1)
dirToVec '<' = (-1,0)
dirToVec '>' = (1,0)
dirToVec 'v' = (0,-1)

addVec (x1, y1) (x2, y2) = (x1+x2, y1+y2)

mapDirs :: [Char] -> [(Int, Int)]
mapDirs directions = scanl addVec (0,0) (map dirToVec directions)

countHouses :: [Char] -> Int
countHouses directions = length . nub $ mapDirs directions

countHouses2 :: [Char] -> Int
countHouses2 directions = length . nub $ (santaDirs ++ robotDirs)
   where nDirs = length directions
         santaDirs = mapDirs [directions!!i | i <- [0,2..(nDirs-1)]]   
         robotDirs = mapDirs [directions!!i | i <- [1,3..(nDirs-1)]]   

main = do
    inpt <- getInpt

    let solnPart1 = countHouses inpt
    putStrLn $ "Solution to Day 3, Part 1: " ++ show solnPart1

    let solnPart2 = countHouses2 inpt
    putStrLn $ "Solution to Day 3, Part 2: " ++ show solnPart2
