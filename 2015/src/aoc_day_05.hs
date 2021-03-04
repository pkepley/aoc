{-- 
 Solutions for Day 05!

 Part 1: Check strings for naughtiness/niceness.
 Part 2: Check strings for naughtiness/niceness, but more! 
 
 https://adventofcode.com/2015/day/05
--}

import Data.List (tails, group, sort, isInfixOf)

getInpt :: IO [Char]
getInpt = do readFile "../input/input_day_05.txt"

-- Count occurences in a list
tabulate :: (Ord a) => [a] -> [(a, Int)]
tabulate xs = map (\x -> (head x, length x)) $ group $ sort xs 

-- Rolling windows of length n of a list
windows :: Int -> [a] -> [[a]]
windows n xs = takeWhile (\x -> length x == n) $ map (take n) (tails xs)

-- Does a list have a disjoint repetitions of a 2 element substring?
hasTwoRep :: (Eq a) => [a] -> Bool
hasTwoRep xs 
   | length xs < 2 = False
   | take 2 xs `isInfixOf` (tail . tail $ xs) = True
   | otherwise = hasTwoRep $ tail xs

-- Sublist with every other element beginning from index 0
evenSublist :: [a] -> [a]
evenSublist [] = []
evenSublist (x:xs) = x:oddSublist xs

-- Sublist with every other element beginning from index 1
oddSublist :: [a] -> [a]
oddSublist [] = []
oddSublist (x:xs) = evenSublist xs

-- List of two elements --> Tuple with two elements
-- https://stackoverflow.com/a/2921380
tuplify2 :: [a] -> (a,a)
tuplify2 [x,y] = (x,y)

-- Is the same character repeated consecutively in a list?
hasAdjacentRep :: (Eq a) => [a] -> Bool
hasAdjacentRep xs = not (null $ filter (\(a,b) -> (a,b) == (a,a)) $ map tuplify2 $ windows 2 xs)

-- Does a list have non-consecutive repetitions?
hasNonConsecRep :: (Eq a) => [a] -> Bool
hasNonConsecRep xs
   | length xs < 3 = False
   | otherwise = hasAdjacentRep (evenSublist xs) || hasAdjacentRep (oddSublist xs)

-- Use to solve part 1
isNice1 :: String -> Bool
isNice1 str =
    let charCounts = tabulate str
        nVowels = length $ filter (`elem` "aeiou") str
        consecDoubles = filter (\c -> replicate 2 c `isInfixOf` str) 
            $ map fst 
            $ filter (\(c,n) -> n >= 2) charCounts 
        -- Conditions to check:
        hasEnoughVowels = nVowels >= 3
        hasConsecDoubles = not (null consecDoubles)
        hasNoForbidden = all (\s -> not $ s `isInfixOf` str) ["ab", "cd", "pq", "xy"]

    in hasEnoughVowels && hasConsecDoubles && hasNoForbidden

-- Use to solve part 2
isNice2 :: String -> Bool
isNice2 str = hasTwoRep str && hasNonConsecRep str

main = do
    inpt <- getInpt

    let solnPart1 = length $ filter isNice1 $ lines inpt
    putStrLn $ "Solution to Day 5, Part 1: " ++ show solnPart1

    let solnPart2 = length $ filter isNice2 $ lines inpt
    putStrLn $ "Solution to Day 5, Part 2: " ++ show solnPart2
