-- Tutorial
testList = [3,4,8,4,6]

dM x = x*2

dU x y = (x*2,x*y)

dSN x = if x > 100 then x else x*2
dSN' x = succ $ if x > 100 then x else x*2 

cOB = "It's a-me, Conon O'Brien!"

rLen :: (Num b) => [a] -> b
rLen [] = 0
rLen (_:xs) = 1 + rLen xs

rSum :: (Num a) => [a] -> a
rSum [] = 0
rSum (x:xs) = x + rSum xs

rPro :: (Num a) => [a] -> a
rPro [] = 1
rPro (x:xs) = x * rPro xs
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
 | bmi <= skinny = "You're underweight, you emo, you!"
 | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"
 | bmi <= fat = "You're fat! Lose some weight, fatty"
 | otherwise = "You're a whale, congratulations!"
 where bmi = weight / height ^ 2
       skinny = 18.5
       normal = 25.0
       fat = 30.0



-- Eulers
euler5 q = sum $ [ x| x <- [5,10..q], x`mod`3 /= 0 ] ++ [3,6..q]

-- Experiments
len' x = sum [ 1 | i <- x ]
crop' x y z = [z !! i | i <- [x..y]]

set x = [ i | i <- [1..maximum x], i `elem` x ]

set' (x:xs)
 | xs == [] = [x]
 | elem x xs = x:set' [ i | i <- xs, i /= x ]
 | True = x:set' xs

fib' f s r
-- fib' f = fib' 1 1 f
 | r == 0 = []
 | True = f:fib' s (f+s) (r-1)

qs [] = []
qs (x:xs) = le ++ [x] ++ gt
 where le = qs [ i | i <- xs, i <= x ]
       gt = qs [ i | i <- xs, i > x ]

qs' [] = []
qs' (x:xs) = (qs' [i|i<-xs,i<=x]) ++ [x] ++ (qs' [i|i<-xs,i>x])

sort' (x:xs)
 | null xs = [x]
 | null [ i | i <- xs, i < x ] = x:sort' xs
 | True = sort' $ xs++[x]

mod' :: Integral a => a -> a -> a
mod' f s | f < s = f | True = mod' (f-s) s

-- div' :: Integral a => a -> a -> a -- floor division
div' f s | f < s = 0 | True = 1 + div' (f-s) s

-- max' :: Integral a => [a] -> a
max' (x:xs) | xs == [] = x 
 | x < (head xs) = max' xs
 | True = max' (x:tail xs)

-- sieve (not erastosthene's) 
primes (x:xs)
 | xs == [] = []
 | True = x:primes [ i | i <- xs, 0 /= rem i x ]

-- cz :: (Integral a) => a -> [a]
cz x|x==1=[1]|odd x=x:cz(3*x+1)|True=x:cz(div x 2)

cz1 :: (Integral a) => a -> [a]
cz1 x | x == 1 = [1] | odd x = x:cz1 (3*x+1) | True = x:cz1 (div x 2)

cz2 :: (Integral a) => a -> [a]
cz2 x | x == 1 = [1] | True = x:cz2 (if odd x then 3*x+1 else div x 2)

