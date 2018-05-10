-- sampleData
sampleList = [3,6,4,8,4]

-- end

-- misc
eul5 r | r == 0 = 0
 | rem r 3 == 0 = r + next
 | rem r 5 == 0 = r + next 
 | True = next
 where next = eul5 $ r-1
-- end


len' :: Integral a => [a] -> a
len' (x:xs)
 | xs == [] = 1
 | True = 1 + len' xs

sum' :: Integral a => [a] -> a
sum' (x:xs)
 | xs == [] = x
 | True = x + sum' xs

--div' :: Integral a => a -> a -> a
-- div' x y | 

max' :: Ord a => [a] -> a
max' (x:xs) | xs == [] = x
 | x <= head xs = max' xs
 | True = max' (x:tail xs)


-- avg' :: (Integral a,Fractional a) => [a] -> a
-- avg' l = ((sum' l) / (len' l))
