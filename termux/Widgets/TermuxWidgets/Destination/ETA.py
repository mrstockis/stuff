
#!/bin/python

from subprocess import Popen, check_output
import json

def shell(cmd):
  Popen(cmd,shell=True).wait()

end =   [-17.8929, 177.2064]


cur_pos = json.loads( check_output(["termux-location"]).decode('ascii').replace('\n','') )
cur_vel = cur_pos['speed']
cur_pos = [ cur_pos['latitude'] , cur_pos['longitude'] ]

cur_dist = ((end[0] - cur_pos[0])**2 + (end[1] - cur_pos[1])**2) ** .5
eta = round(1852*60*cur_dist/cur_vel,10)

epoc = check_output(["date","+%s"]).decode('ascii').replace('\n','')
eta = int(epoc) + eta
eta = check_output(f'date --date=@{eta}'.split()).decode('ascii').replace('\n','')
shell(f'termux-toast ETA: {eta}')


shell(f'termux-notification -i 99 -t "Anchor Grogg" -c "ETA: {eta}"')
