
Q=1000

result = sum( [ i for i in range(3,Q,3) ] + [ i for i in range(5,Q,5) if not i%3 == 0 ] )

print(result)
