
import System.IO

fibSum x = seq 1 1 x
 where seq a b c
        | b > c = 0
        | even b = b + seq b (a+b) c
        | True = seq b (a+b) c

result = fibSum 4000000

main = do
 print result
