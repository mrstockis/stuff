
from bs4 import BeautifulSoup as Soup
from urllib.request import urlopen,Request
from subprocess import call

## NEEDS ##
# neat header "This is GP" or smthn
# visa först brödtext när man valt artikel, Sen artikel vid vidare tomt input; spara i egen dikt   inputNr : brödtext

urlMain = "http://www.gp.se/ledare"

def T(var,comment): # Test
    t = type(var)
    v = var
    print(" T E S T  # {}\nType: {}\nValue: {}\n".format(comment,t,v))

def Souper(url): # input: the url to soupify
    agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36\(KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36'
    request = Request(url,headers={"User-Agent":agent})
    html = urlopen(request).read().decode()
    soup = Soup(html,"html.parser")
    return soup

def Find(soup,tag,name): # name of a class
    boxes = soup.findAll(tag,{"class":name})
    return boxes

def Format(text,start = 0): # start 'at'
    Li = (text).split(" ")[start:] # a list of elements by space
    wordLen = 0
    for i,v in enumerate(Li):
        wordLen += len(v)
        if "\n" in v:
            wordLen = 0
        if wordLen > 60:
            Li.insert(i,"\n")
            wordLen = 0
    return (" ").join(Li)


def Main():  # 
    soup = Souper(urlMain)
    bxMain = Find(soup,"a","teaser__link")
    
    select,bread,num = {},{},1
    for i in bxMain[:30]:
        if i.h2:
            form = Format(i.h2.text,6)
            print(" {}: {}".format(num,form))
            select[num]=urlMain+i["href"][7:]
            num += 1
    return select

def Art(choice):
    soup = Souper(choice)
    bxArt = Find(soup,"div","article__body__richtext container ")
    
    article = open("articleGP.txt","w")
    for i in bxArt:
        article.write( Format(i.text) )
        article.write( "\n" )
    article.close()

try:
    while True:
        print( "\n  GP - Ledare \n\n" )
        select = Main()
        inp = int( input("Article: ") )
        Art( select[inp] )
        call( ["less","articleGP.txt"] )
        call( ["clear"] )
        call( ["rm","articleGP.txt"] )
except: KeyboardInterrupt
quit()

