#Normal Method
"""
hand = open('angle.txt')
for line in hand:
	line = line.rstrip()
	if line.startswith('computer') :
		print line		
"""

#Regular Expression Method:
"""
import re

hand = open('angle.txt')
for line in hand:
	line = line.rstrip()
	if re.search('^computer', line) :
		print line
"""

#Wildcard Regular Expression Method:

import re

hand = open('angle.txt')
for line in hand:
	line = line.rstrip()
	if re.search('^c.*er', line) :
		print line
# "^" is a regular expression for "start of the line"
# "." is a regular expression for "any character"
# "*" is a regular expression for "many times"
# ".*" is a regular expression combo to make it match as many characters as it needs


