{-- 
 Solutions for Day 2!

 Part 1: How much wrapping paper?
 Part 2: How much ribbon?
 
 https://adventofcode.com/2015/day/2
--}

import Data.List.Split (splitOn) 

getInpt :: IO [Char]
getInpt = do readFile "../input/input_day_02.txt"

getDims :: String -> [Int]
getDims dimstring = map (\x -> read x::Int) $ splitOn "x" dimstring

area :: [Int] -> Int
area [l,w,h] =
    2 * sum areas + minimum areas
    where areas = [l*w, w*h, h*l]

bowLength :: [Int] -> Int
bowLength [l,w,h] = boxRibbon + bowRibbon
    where boxRibbon = 2 * minimum [l+w, l+h, h+w]
          bowRibbon = l*w*h           

totalAreaFromList :: String -> Int
totalAreaFromList areas =
    sum $
    map (area . getDims) $
    lines areas   

totalBowLengthFromList :: String -> Int
totalBowLengthFromList areas =
    sum $
    map (bowLength . getDims) $
    lines areas

main = do
    inpt <- getInpt

    let solnPart1 = totalAreaFromList inpt
    putStrLn $ "Solution to Day 2, Part 1: " ++ show solnPart1

    let solnPart2 = totalBowLengthFromList inpt
    putStrLn $ "Solution to Day 2, Part 2: " ++ show solnPart2
