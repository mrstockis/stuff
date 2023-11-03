#!/bin/python3

from subprocess import Popen,check_output
from time import sleep
import json


Anchor = {}
interval = ''
sampleSize = ''
MaxRadia = 0
MaxIncre = 0


def color(txt,col):
  colors = {
      'dark': '\033[2m',
      'clear': '\033[0m',
      'blue': '\033[34m',
      'teal': '\033[36m',
      'red': '\033[31m',
      'green': '\033[32m',
      'orange': '\033[33m'
  }
  return f'{colors[col]}{txt}{colors["clear"]}'


#Multi = 1000000 # Multiplier to dodge non numeric format for low floating points, like  4.4593e-5

def shell(cmd,answer=False):
  if answer:
    answer = check_output(cmd.split()).decode('ascii').replace('\n','')
    return answer
  else:
    Popen(cmd,shell=True).wait()


def origo():
  global sampleSize
  ori = { 'lat': 0, 'lon': 0 }
  for i in range(sampleSize):
    sample = json.loads( shell("termux-location",1) )
    sample[ 'latitude'] = round(sample[ 'latitude'],8)
    sample['longitude'] = round(sample['longitude'],8)
    sample[ 'accuracy'] = round(sample[ 'accuracy'],8)

    ori['lat'] += sample[ 'latitude']/(sample['accuracy']*sampleSize)
    ori['lon'] += sample['longitude']/(sample['accuracy']*sampleSize)

  return ori


def magnitude():
  global Anchor, sampleSize
  #print("Magnitude function")
  #print(f'(global)Anchor: {Anchor}')
  #print(f'(global)sampleSize: {sampleSize}')

  mag = 0   # magnitude
  #print("@loop")
  for i in range(sampleSize):
    sample = json.loads( shell("termux-location",1) )
    sample[ 'latitude'] = round(sample[ 'latitude'],8)
    sample['longitude'] = round(sample['longitude'],8)
    sample[ 'accuracy'] = round(sample[ 'accuracy'],8)

    #print(f'sample: {sample}')
    lat = Anchor['lat'] - sample[ 'latitude']/sample['accuracy']
    #print(f'lat: {lat}')
    lon = Anchor['lon'] - sample['longitude']/sample['accuracy']
    #print(f'lon: {lon}')
    mag += ( lat**2 + lon**2 ) ** 0.5
    #print(f'mag: {mag}')
		
  #print("endLoop")
  mag = mag / sampleSize
  #print(f'final mag: {mag}')
  #quit()
  return mag


def setup():
  global Anchor, MaxRadia, MaxIncre, interval, sampleSize

  shell("clear")

  print( '\nAnchor Guard {}'.format(
      shell('date +%H:%M:%S___%F',1)
      )
  )
  
  print('{} {}\b'.format(
    color("Set interval in sec: ",'orange'),
    color("0","dark")
    ), end=''
  )
  interval = input()
  interval = int(interval) if len(interval) else 0

  print('{} {}\b'.format(
    color("Set sample size: ",'orange'),
    color("1","dark")
    ), end=''
  )
  sampleSize = input()
  sampleSize = int(sampleSize) if len(sampleSize) else 1


  print(" {} ".format(
    color("Press enter when anchor drops",'green')
    ), end=''
  ) ; input()
  print("{}  Fetching position".format(
    shell( 'date +%H:%M:%S',1 )
    )
  )

  Anchor = origo()

  print("{}  Anchor drop registered".format(
    shell('date +%H:%M:%S',1)
    )
  )

  sleep(1)

  print(" {} ".format(
    color("Press enter when anchor stretched",'green')
    ), end=''
  ) ; input()
  print("{}  Fetching position".format(
    shell( 'date +%H:%M:%S',1 )
    )
  )

  MaxRadia = magnitude()
  MaxIncre = MaxRadia * 0.1

  print("{}  Max Radius registered".format(
    shell('date +%H:%M:%S',1)
    )
  )
  
  sleep(1)

  print(" {} ".format(
    color("Press enter when engine's off to start monitoring", 'green')
    ), end=""
  ) ; input() ; print()



def monitor():
  global Anchor, MaxRadia, interval, sampleSize

  shell("tput sc")
  shell("tput civis")
  
  print()
  
  while True:
    curMag = magnitude()
    
    if curMag > MaxRadia:
      shell('tput rc')
      print("\n {}\n".format( color("Anchor drag:",'red') ) )
      shell("termux-vibrate -f &")
      #mpv OTH.mp3

      # Run some alarm or tune, to ask if it's false alarm
      ans = input(" False alarm? y/N ")
      shell('tput rc')
      print(" "*300)
      shell('tput rc')
      
      if ans == 'y' or ans == 'Y':
        #print(f'curMag: {curMag}')
        #sleep(1)
        #print(f'oldMax: {MaxRadia}')
        #sleep(1)
        MaxRadia += MaxIncre
        #shell('clear')
        #print(f'newMax: {MaxRadia}')
        #sleep(1)
        #input()
        #shell('clear')
      else:
        break


    shell("tput rc")

    print(" {} {}  {} {}  {} {}".format(
      color('Last reccord:','teal'),
      shell('date +%H:%M:%S',1),
      color('Interval:','teal'),
      f'{interval} seconds',
      color('Samples:','teal'),
      sampleSize
      )
    )
    
    Pper = round( 100 * curMag/MaxRadia )
    Pbar = int( Pper/2 )

    #print(f"""Anchor: {Anchor}\n
    #interval: {interval}\n
    #sampleSize: {sampleSize}\n
    #maxRadia: {MaxRadia}\n
    #curMag: {curMag}\n
    #Pper: {Pper}\n
    #Pbar: {Pbar}"""
    #)
    #sleep(5)

    Nbar = ' '

    if Pper >= 100:
      warn = '{}{}{}'.format(
        " "*23 +
        color(Pper,'red') +
        " "*200
        )
      print(warn)
      shell(f'termux-notification -i 99 -t "Anchor Guard" -c "{warn}"')
      shell('tput rc')
    else:
      for i in range(50):
        if Pbar >= i:
          Nbar=Nbar+'|'
        else:
          Nbar=Nbar+'-'

      Nbar = Nbar + f' {Pper} % '
      print(Nbar)
      #Nbar = Nbar.replace('|','+')
      shell(f'termux-notification -i 99 -t "Anchor Guard" -c "{Nbar}"')

  


def end():
  shell( "termux-notification-remove 99" )
  print()
  shell("tput cnorm")
  




def main():
  setup()   # Set interval, sampleSize, pos.anchor pos.max
  try:
    monitor() # Update pos and show. Check for false alarms
  except:
    KeyboardInterrupt
  end()     # Restore tput etc.



main()
