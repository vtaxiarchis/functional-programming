import Data.Char (digitToInt)
import Data.List
import Test.QuickCheck

data Sudoku = Sudoku { rows :: [[Maybe Int]] } deriving (Show)


example :: Sudoku
example =
    Sudoku
      [ [j 3,j 6,n  ,n  ,j 7,j 1,j 2,n  ,n  ]
      , [n  ,j 5,n  ,n  ,n  ,n  ,j 1,j 8,n  ]
      , [n  ,n  ,j 9,j 2,n  ,j 4,j 7,n  ,n  ]
      , [n  ,n  ,n  ,n  ,j 1,j 3,n  ,j 2,j 8]
      , [j 4,n  ,n  ,j 5,n  ,j 2,n  ,n  ,j 9]
      , [j 2,j 7,n  ,j 4,j 6,n  ,n  ,n  ,n  ]
      , [n  ,n  ,j 5,j 3,n  ,j 8,j 9,n  ,n  ]
      , [n  ,j 8,j 3,n  ,n  ,n  ,n  ,j 6,n  ]
      , [n  ,n  ,j 7,j 6,j 9,n  ,n  ,j 4,j 3]
      ]
  where
    n = Nothing
    j = Just

-- Function that generates an empty Sudoku table
allBlankSudoku :: Sudoku
allBlankSudoku = Sudoku ([row | _ <- [1..9]])
                 where row = [Nothing | _ <- [1..9]]

-- Function that checks if given Sudoku table is valid
isSudoku :: Sudoku -> Bool
isSudoku s = (length (rows s) == 9) &&
            and [ length r == 9 | r <- (rows s)] &&
            and [ check r | r <- (rows s)]
         where check [] = True
               check (Nothing:xs) = check xs
               check (Just n:xs) = (n >= 1 && n <= 9) && check xs

-- Function that checks if all cells of Sudoku table is filled
isFilled :: Sudoku -> Bool
isFilled s = and [check r | r <- (rows s)]
                 where check [] = True
                       check (Nothing:xs) = False
                       check (_:xs) = check xs

-- Helper method that prints rows of a Sudoku table
printSudoku' :: [[Maybe Int]] -> IO ()
printSudoku' [] = do putStrLn ""
printSudoku' (x:xs) = do putStrLn (convert x)
                         printSudoku' xs
                      where convert [] = ""
                            convert (Nothing:xs) = '.' : convert xs
                            convert (Just n:xs) = (show n) ++ convert xs


-- Function to print a Sudoku table
printSudoku :: Sudoku -> IO ()
printSudoku s = printSudoku' (rows s)


-- Helper function that reads lines from a file and converts them to a nested list of Maybe values
readSudoku' :: [String] -> [[Maybe Int]] -> Sudoku
readSudoku' [] r = (Sudoku r)
readSudoku' (x:xs) r = readSudoku' xs ((convert x) : r)
                       where convert [] = []
                             convert ('\n':rest) = []
                             convert ('.':rest) = Nothing : (convert rest)
                             convert (n:rest) =  (Just (digitToInt n)) : convert rest

-- Function that reads Sudoku table from file. Returns a blank Sudoku if not valid.
readSudoku :: FilePath -> IO Sudoku
readSudoku f = do str <- readFile f
                  let ws = lines str
                  let s = readSudoku' ws []
                  if not (isSudoku s)
                    then return allBlankSudoku
                  else return s

-- Function to generate a random cell
cell :: Gen (Maybe Int)
cell = frequency [(9, return Nothing), (1, do n <- choose(1,9); return (Just n))]

instance Arbitrary Sudoku where
  arbitrary =
    do rows <- vectorOf 9 (vectorOf 9 cell)
       return (Sudoku rows)

-- Property to ensure generated Sudoku is valid
prop_Sudoku :: Sudoku -> Bool
prop_Sudoku s = isSudoku s


type Block = [Maybe Int]

-- Function to determine if block contains duplicates or not
isOkayBlock :: Block -> Bool
isOkayBlock b = (length (nub b')) == (length b')
                where b' = filter (\cell -> cell /= Nothing) b

-- Function that takes 3 rows of a Sudoku table, and generates blocks of size 9.
-- Recursively takes first 3 elements of each row to accumulate them in a block.
generate3Blocks' :: [[Maybe Int]] -> [[Maybe Int]]
generate3Blocks' ([[],[],[]]) = []
generate3Blocks' rows =
  foldr (++) [] ([ take 3 r | r <- rows]) : generate3Blocks' ([ drop 3 r | r <- rows])

-- Function that takes rows of a Sudoku table and generates 3-square blocks from them
generate3Blocks :: [[Maybe Int]] -> [[Maybe Int]]
generate3Blocks rows = (generate3Blocks' (take 3 rows)) ++
                       (generate3Blocks' (take 3 (drop 3 rows))) ++
                       (generate3Blocks' (take 3 (drop 6 rows)))

-- Function to generate blocks of a Sudoku table
blocks :: Sudoku -> [Block]
blocks s = allRows ++ generate3Blocks allRows ++ (transpose allRows)
          where allRows = rows s

-- Property to check correct number of blocks generated and all blocks are of size 9
prop_BlockAmount :: Sudoku -> Bool
prop_BlockAmount s = length b == 27 && all (\block -> length block == 9) b
                     where b = blocks s

-- Function to determine if all blocks of a Sudoku table is valid
isOkay :: Sudoku -> Bool
isOkay s = all isOkayBlock (blocks s)

type Pos = (Int,Int)

-- Function that generates a list of blank positions and accumulates them in a given list based
-- on calculated row and column numbers
blanks' :: [[Maybe Int]] -> [(Int, Int)] -> Int -> [(Int, Int)]
blanks' [] b _ = b
blanks' (x:xs) b row = blanks' xs ((b ++ adder x [] 0)) (row + 1)
  where adder [] pairs _ = pairs
        adder (Nothing:xs) pairs col = adder xs ((row, col):pairs) (col + 1)
        adder (_:xs) pairs col = adder xs pairs (col + 1)

-- Function to generate a list of blank positions
blanks :: Sudoku -> [Pos]
blanks s = blanks' (rows s ) [] 0

-- Property to check all calculated blank cells have blank value
prop_BlanksAreReallyBlank :: Sudoku -> Bool
prop_BlanksAreReallyBlank s = all (\p -> ((rows' !! (fst p)) !! (snd p)) == Nothing) pos
                             where pos   = blanks s
                                   rows' = rows s

