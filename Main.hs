module Main where

import Data.List (groupBy, sortOn)

data Point = Point Int Int
           deriving Show

type Tree = [Point]

trunk :: Point -> Int -> Tree
trunk (Point x y) size = [Point x (y + d) | d <- [1..size]]

split :: Point -> [Point]
split (Point x y) = [Point (x + 1) (y + 1), Point (x - 1) (y + 1)]

branch :: Point -> Int -> Tree
branch start = branch' [start]
  where branch' _ 0 = []
        branch' [single] size = split single ++ branch' (split single) (size - 1)
        branch' points size = widen points ++ branch' (widen points) (size - 1)
          where widen [Point leftx lefty, Point rightx righty] = [Point (leftx + 1) (lefty + 1), Point (rightx - 1) (righty + 1)]

tree :: Point -> Int -> Int -> Tree
tree _ _ 0 = []
tree start size splits =
  let trunks = trunk start size
      branches = branch (last trunks) size
  in
    trunks ++ branches ++ concat [tree st (size `div` 2) (splits - 1) | st <- take 2 $ reverse branches]

formatTree :: Int -> Tree -> [String]
formatTree width = map (\points -> map (\x -> if x `elem` map (\(Point x _) -> x) points then '1' else '_') [1..width])
                   . groupBy (\(Point _ y1) (Point _ y2) -> y1 == y2)
                   . sortOn (\(Point _ y) -> y)

main :: IO ()
main = do
  sizeStr <- getLine
  let splits = read sizeStr
  mapM_ putStrLn $ reverse $ formatTree 100 $ tree (Point 50 0) 16 splits
