
import System.IO

--primes :: Integral a => a -> [a]
primes x = field [ 0 | _ <- [2..x] ] 2
 where field (x:xs) c
        | null xs = []
        | x == 0 = c:field (sieve xs (c-1) (c-1)) (c+1)
        | otherwise = field xs (c+1)
        where sieve (x:xs) d e
               | null xs = [0]
               | d == 0 = 1:sieve xs e e
               | otherwise = x:sieve xs (d-1) e

--isPrime :: Integral a => a -> Bool
isPrime x = test (primes $ div x 2) x
 where test (x:xs) b
        | null xs = True
        | rem b x == 0 = False
        | otherwise = test xs b

--primeFactors :: Integral a => a -> [a]
primeFactors x
 | isPrime x = [x]
 | otherwise = factors (primes (1 + div x 2)) x 
 where factors (x:xs) b
        | b == 1 = []
        | rem b x == 0 = x:factors (x:xs) (div b x)
        | otherwise = factors xs b

main = do
 print $ primeFactors 600851475143



