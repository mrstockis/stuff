
import System.IO

result = sum $ [ i | i <- [3,6..999], rem i 5 /= 0 ] ++ [5,10..999]

main = do
 print result
