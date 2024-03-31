#!/bin/python3

# Just like the tree command, but flattens the files to be shown horizontally rather than vertically

import json
from sys import argv
from subprocess import Popen, check_output

nl_prefix = False
nl_surfix = False

def traverse(branch, level = 0):
    global data
    global nl_prefix
    global nl_surfix

    postDir = False

    col = ''
    cE = '\033[0m'
    indentSep  = "\033[2;30m|\033[0m "
    indent = indentSep * 1 * level
    fileSep   = "\033[30m o \033[0m"

    '''
    match level:
        case 1|6:  col = ''
        case 2|7:  col = '\033[1;30m'
        case 3|8:  col = '\033[2m'
        case 4|9:  col = '\033[30m'
        case 5|10: col = '\033[2;30m'
    '''
    lvl = level%3
    match lvl:
        case 1:  col = '\033[37m'
        case 2:  col = '\033[2;37m'
        case 0:  col = '\033[2;36m'


    cw = 0 * int( 1 * len(indent) + 1 * len(fileSep) )

    if nl_surfix:
        print( indent, end = '')

    for n,thing in enumerate(branch):
        cw += 1 * len( thing['name'] ) + 1 * len(fileSep)

        if thing['type'] == 'directory':
            cw = len(indent)
            if not nl_surfix and level:
                print('')
                nl_prefix = True
                nl_surfix = False

            print( f'{ indent }' if n > 0 else '' ,end = '' )
            print( '\033[34m' + thing['name'] + '\033[0m')
            nl_surfix = True

            if 'contents' in thing.keys():
                postDir = True
                traverse( thing['contents'], level+1 )

        else:
            if postDir:
                print( indent, end ='' )
                postDir = False

            nl_prefix = False
            nl_surfix = False

            if cw >= data['width']:
                print( '\n' + indent, end = ''); cw = len(indent) + len(fileSep)
                nl_prefix = True

            if n < len(branch)-1:
                next_thing = branch[n+1]
                
                if next_thing['type'] == 'directory':
                    print( col + thing['name']+cE,end='')
                    continue
                else:
                    print( col + thing['name'] + cE, end = fileSep)
            else:
                if thing['type'] == 'directory':
                    print( col + thing['name'] + cE, end=f"")
                else:
                    print( col + thing['name'] + cE, end=f"\n")
                    nl_surfix = True
    #


def summary( report ):
    report = [''] + [ f'{key}: {report[key]}' for key in report.keys() if key not in 'type'] + ['']
    report = "   ".join( report )
    
    #bar = '\033[30m' + "-" * (len(report)+0) + '\033[0m'
    global width
    bar = '\033[30m' + "-" * width + '\033[0m'

    print( 0*'\n' + bar )
    print( '\033[33m' + report + '\033[0m' )
    #print( bar )


def shell(cmd, response = 0):
    if response:
        return check_output(cmd.split()).decode('utf-8')
    else:
        Popen(cmd,shell=True).wait()


if len(argv) == 0:
    print("""
Parameters
    First: start location
   Second: flags given to tree
    Third: filter given to grep
    """)
    quit()


if len(argv) > 3:
    flags = " ".join(argv[1:len(argv)-1])
else:
    flags = ''


directory = argv[len(argv)-1]

jsn = shell(f'tree -J{flags} {directory}', 1)
jsn = json.loads(jsn)

width = int( shell('tput cols',1) ) * 1


data = {
        'dir': directory,
        'flg': flags,
        'tree': jsn[0],
        'report': jsn[1],
        'width': width
}


def main():
    global data
    shell('tput civis')
    traverse( [ data['tree'] ] )
    summary( data['report'] )
    shell('tput cnorm')


#shell(f'tput cuu1',0)
main()

