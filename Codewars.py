# The supermarket queue - kata6
# what is the total time of all customers, taking their unique time, using n number of tills, are all done?

'''
EX.
queue_time([5,3,4], 1)
# should return 12
# because when n=1, the total time is just the sum of the times

queue_time([10,2,3,3], 2)
# should return 10
# because here n=2 and the 2nd, 3rd, and 4th people in the
# queue finish before the 1st person has finished.

queue_time([2,3,10], 2)
# should return 12
'''

def queue_time(customers, n):
    time = 0
    tills = [ customers.pop(0) for i in range(n) if len(customers) ]
    while sum(tills):
        time += 1
        tills = [ i-1 for i in tills if 0 < i ]
        for i,v in enumerate(tills):
            if not v and len(customers):
                tills[i] = customers.pop(0)
    return time

def queue_time(cu,n):
    l=[0]*n
    for i in cu:
        l[l.index(min(l))] += i
    return max(l)

print( queue_time([], 1) )          # 0
print( queue_time([5,3,4], 1) )     # 12
print( queue_time([10,2,3,3], 2) )  # 10
print( queue_time([2,3,10],2) )     # 12
