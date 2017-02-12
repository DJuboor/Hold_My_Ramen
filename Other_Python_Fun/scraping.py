"""
import socket
mysock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
mysock.connect(('https://rodviewer.montcopa.org/countyweb/disclaimer.do', 80))

mysock.send('GET https://rodviewer.montcopa.org/countyweb/disclaimer.do HTTP/1.0\n\n')

while True:
	data = mysock.recv(512)
	if ( len(data) < 1) :
		break
	print data
mysock.close()
"""

"""
import urllib
fhand= urllib.urlopen('https://rodviewer.montcopa.org/countyweb/transaction/transAddDoc.do?readonly=true&searchSessionId=searchJobMain&countyname=Montgomery&usage=ADVSCH&skipDBSwitch=true&pagenum=1&printview=true')

counts = dict()
for line in fhand:
	words = line.split()
	for word in words:
		counts[word] = counts.get(word,0) + 1
print counts		
"""


import urllib
from BeautifulSoup import *

url =('http://www.py4inf.com')

html = urllib.urlopen(url).read()
soup = BeautifulSoup(html)

# Retrieve a list of the anchor tags
# Each tag is like a dictionary of HTML attributes

tags = soup('a')

for tag in tags:
	print tag.get('href',None)

