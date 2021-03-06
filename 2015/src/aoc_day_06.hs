{-- 
 Solutions for Day 06!

 Part 1: Blinken lights! 
 Part 2: Dimmable lights!
 
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
    array ((0,0), (n-1,n-1)) [((i,j), (False, 0)) | i <- [0..(n-1)], j <- [0..(n-1)]] 

turnOnLight lg (i,j) = snd (lg ! (i,j)) + 1

turnOn lg (ilo, jlo) (ihi, jhi) =
    lg // [((i, j), (True, turnOnLight lg (i,j))) | i <- [ilo..ihi], j <- [jlo..jhi]]

turnOffLight lg (i,j) = max 0 (snd (lg ! (i,j)) - 1)

turnOff lg (ilo, jlo) (ihi, jhi) =
    lg // [((i, j), (False, turnOffLight lg (i,j))) | i <- [ilo..ihi], j <- [jlo..jhi]]

toggleUpLight lg (i,j) = snd (lg ! (i,j)) + 2

toggle lg (ilo, jlo) (ihi, jhi) =
    lg // [((i, j), (not . fst $ lg ! (i,j), toggleUpLight lg (i,j))) | 
               i <- [ilo..ihi], j <- [jlo..jhi]]

applyInstr lg instr
    | "turn on" `isInfixOf` instr = turnOn lg loPos hiPos
    | "turn off" `isInfixOf` instr = turnOff lg loPos hiPos
    | "toggle" `isInfixOf` instr = toggle lg loPos hiPos
    where split1 = splitOn " through " instr
          split2 = words $ head split1
          hiPos  = tuplify2 $ map (\x -> read x :: Int) $ splitOn "," $ last split1
          loPos  = tuplify2 $ map (\x -> read x :: Int) $ splitOn "," $ last split2

--applyAllInstrs lg [] = lg
--applyAllInstrs lg (instr:instrList) = applyAllInstrs (applyInstr lg instr) instrList
applyAllInstrs = foldl applyInstr 

main = do
    inpt <- getInpt

    let lightShow = applyAllInstrs (lightgrid 1000) (lines inpt)

    let solnPart1 = length $ filter fst $ elems lightShow
    putStrLn $ "Solution to Day 6, Part 1: " ++ show solnPart1

    let solnPart2 = sum $  map snd $ elems lightShow
    putStrLn $ "Solution to Day 6, Part 1: " ++ show solnPart2
