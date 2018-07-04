
from bs4 import BeautifulSoup as Soup
from urllib.request import urlopen,Request
from subprocess import call

urlMain = "http://www.gp.se/ledare"

# I: url
# { sneaky scraper soupyfies html content }
# O: souped html (bs4 structured)
def Souper(url):
    agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36\(KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36'
    request = Request(url,headers={"User-Agent":agent})
    html = urlopen(request).read().decode()
    soup = Soup(html,"html.parser")
    return soup

# I: bs4 soup, tag, class name
# { creates a list storing stringboxes of search hits }
# O: list of list of hits
def Find(soup,tag,name):
    boxes = soup.findAll(tag,{"class":name})
    return boxes

# I: string, readFromPosition, customLineBreak
# { turn string to list of words,  inserts \n at specific count }
# O: rejoined string
def LineBreak(text,start = 0,lnBreak = 60):
    Li = (text).split(" ")[start:]
    wordLen = 0
    for i,v in enumerate(Li):
        wordLen += len(v)
        if "\n" in v:
            wordLen = 0
        if wordLen > lnBreak:
            Li.insert(i-1,"\n")  # newline before the word that tresspassed limit
            wordLen = 0
    return (" ").join(Li)

# Called 
# { offer article selection, accepts user selection }
# O: url of selected article
def Selection():
    soup = Souper(urlMain)
    titles = Find(soup,"a","teaser__link")
    num,select = 1,{}
    for a in titles[:30]:
        if a.h2:
            title = LineBreak(a.h2.text,6)
            print(" {}: {}".format(num,title))
            select[num]=urlMain+a["href"][7:]
            num += 1
    return select

# I: url of a selected title
# { soup article source, find paragraphs, write each to doc seperated with newline }
# O: none
def Article(choice):
    soup = Souper(choice)
    paragraphs = Find(soup,"div","article__body__richtext container ")
    doc = open("articleGP.txt","w")
    for paragraph in paragraphs:
        doc.write(LineBreak(paragraph.text))
        doc.write("\n")
    doc.close()

# Called
# { clear screen, header, offer selection, create -, read -, delete article, repeat  }
# Call self
def Main():
    call( ["clear"] )
    print( "\n  GP - Ledare \n\n" )
    select = Selection()
    inp = int( input("Article: ") )
    Article( select[inp] )
    call( ["less","articleGP.txt"] )
    call( ["rm","articleGP.txt"] )

try:
    while True:
        Main()
except: KeyboardInterrupt
