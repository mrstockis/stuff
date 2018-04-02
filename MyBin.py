def T(var,comment):
    print("\n T E S T → {}\nValue: {}\nType: {}".format(comment,var,type(var) ) )

#'''
def MyBin(a):  # expects string
    Str,Base = "",[ 8,4,2,1 ]
    for i in a:
        Bin,Dig = "",int(i)
        for y in Base:
            if y <= Dig: Bin +="1"; Dig -= y
            else: Bin += "0"
#        Comp = "0" * ( 4-len(Bin) )
        Str += Bin  # removed "Comp +", no needed for it?
    return [" ".join(Str[i::4]) for i in range(4) ]

try:
    while True:
        inp = input("Base 10_10 → Base 2_10: ")  #Remain string-type
        if not inp: break
        print("\n",bin(int(inp))[2::],"\n")
        for i in MyBin(inp):
            print(i)
        print("\n")

except: KeyboardInterrupt


'''
4 : 9
8 : 99
12: 999
..:..
4n: 10^n-1
n: 10^(n/4)-1


i:59

b:  8   4   2   1
5:  0   1   0   1   append to S1 → complement 0 and 101 → 0101
9:  1   0   0   1   append to S1 → 01011001

Read S1, 4 times, at index increment(0), steps of 4:
                                        01011001
    S2 = [ S1[0::4] ]   append to S2 →  ↓---↓---    → [01]
    S2 = [ S1[1::4] ]   append to S2 →  -↓---↓--    → [01] [10]
    S2 = [ S1[2::4] ]   append to S2 →  --↓---↓-    → [01] [10] [00]
    S2 = [ S1[3::4] ]   append to S2 →  ---↓---↓    → [01] [10] [00] [11]

Then print each:
    01
    10
    00
    11
    ↓↓
    59
'''
