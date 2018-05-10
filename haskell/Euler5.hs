-- compile with -O2 flag ' ghc -O2 file '
-- can skip input by feeding with ' ./file <<< input '

import System.IO

-- Sum of the iterations needed for any Collatz sequence (its length)
cz' :: (Integral a) => a -> a
cz' x | x == 1 = 1
 | odd x = 1 + cz' (3*x+1)
 | True = 1 + cz' (div x 2)

-- Takes r{ range(integer) } and t{ touple(pair) }. Formats output
result' r t = putStrLn $ 
 "\n|Largest Collatz Sequence|\n" ++
 " Range\tIndex\tSize\n " ++
 a ++ "\t" ++ b ++ "\t" ++ c
 where a = r; b = show $ snd t; c = show $ fst t

main = do
 putStr "Enter range: "
 hFlush stdout
 input' <- getLine
 let maxTouple' = maximum [ ( cz' i, i ) | i <- [1.. read input'] ]
 result' input' maxTouple'
