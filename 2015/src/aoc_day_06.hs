{-- 
 Solutions for Day 06!

 Part 1: Blinken lights! 
 Part 2: 
 
 https://adventofcode.com/2015/day/6
--}

import Data.Array
import Data.List (isInfixOf)
import Data.List.Split (splitOn)

getInpt :: IO [Char]
getInpt = do readFile "../input/input_day_06.txt"

-- List of two elements --> Tuple with two elements
-- https://stackoverflow.com/a/2921380
tuplify2 :: [a] -> (a,a)
tuplify2 [x,y] = (x,y)

lightgrid n =
    array ((0,0), (n-1,n-1)) [((i,j), False) | i <- [0..(n-1)], j <- [0..(n-1)]] 

turnOn lg (ilo, jlo) (ihi, jhi) =
    lg // [((i, j), True) | i <- [ilo..ihi], j <- [jlo..jhi]] 

turnOff lg (ilo, jlo) (ihi, jhi) =
    lg // [((i, j), False) | i <- [ilo..ihi], j <- [jlo..jhi]] 

toggle lg (ilo, jlo) (ihi, jhi) =
    lg // [((i, j), not $ lg ! (i,j)) | i <- [ilo..ihi], j <- [jlo..jhi]] 

applyInstr lg instr
    | ("turn on" `isInfixOf` instr) = turnOn lg loPos hiPos
    | ("turn off" `isInfixOf` instr) = turnOff lg loPos hiPos
    | ("toggle" `isInfixOf` instr) = toggle lg loPos hiPos
    where split1 = splitOn " through " instr
          split2 = words $ head split1
          hiPos  = tuplify2 $ map (\x -> read x :: Int) $ splitOn "," $ last split1
          loPos  = tuplify2 $ map (\x -> read x :: Int) $ splitOn "," $ last split2

applyAllInstrs lg [] = lg
applyAllInstrs lg (instr:instrList) = applyAllInstrs (applyInstr lg instr) instrList

main = do
    inpt <- getInpt

    let solnPart1 = length $ filter (\x -> x) $ elems $ applyAllInstrs (lightgrid 1000) (lines inpt)
    putStrLn $ "Solution to Day 6, Part 1: " ++ show solnPart1

    --let solnPart2 = inpt
    --putStrLn $ "Solution to Day 6, Part 2: " ++ show solnPart2
