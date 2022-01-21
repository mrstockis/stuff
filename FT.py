
#!/bin/python3

# DFT with python
# DFT with numpy

import sys
import numpy as np
from matplotlib import pyplot as plt
from time import sleep

np.tau = np.pi*2


def fprint(text):
  sys.stdout.write(str(text))
  sys.stdout.flush()

def string_to_char(string):
  return [ ord(letter) for letter in string ]

def char_to_string(chars):
  return [ chr(int( np.round(char) ) ) for char in chars ]

def FT(data,res):
  N  = len(data)
  R  = 1  # res/N
  N2 = int(len(data)/2) #+.5)
  a0 = sum(data)/N
  
  wi = [sum([ data[i]*np.cos(n*i*np.tau/N) for i in range(N) ])/N2 for n in range(N2)]
  wj = [sum( [data[j]*np.sin(n*j*np.tau/N) for j in range(N) ])/N2 for n in range(N2)]

  ys=[ 0 for i in range(N) ]
  for f in range(int(N2 * R)): 
    for n in range(N):
      ys[n] += -a0/(N2) + ( wi[f]*np.cos(f*np.tau*n/N) + wj[f]*np.sin(f*np.tau*n/N) )

  return  ys,wi,wj


# Sample waves
lacos = lambda a,f: [ a*np.cos( x * f * np.tau/10) for x in range(10) ]
lasin = lambda a,f: [ a*np.sin( x * f * np.tau/10) for x in range(10) ]
merge = lambda ls: [sum([ ls[e][s] for e in range(len(ls))]) for s in range(len(ls[0]))]
dat = merge( [ lacos(9,4), lasin(2,3), lacos(3,1) ] )

#string="hello__world"
#dat = [ c for c in string_to_char(string) ]

D,I,J = FT(dat,len(dat))
D = [ np.round(d,2) for d in D ]
I = [ np.round(i,2) for i in I ]
J = [ np.round(j,2) for j in J ]

print(" Data\n{}\n\n wCos\n{}\n\n wSin\n{}\n".format(D,I,J))

