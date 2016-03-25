# -*- coding: utf-8 -*-
"""
Created on Tue Mar 22 23:20:18 2016

@author: mekomlusa
"""

import pandas as pd
import numpy as np
import sys  
import os
import re

# Enforce utf-8 encoding within the script
reload(sys)  
sys.setdefaultencoding('utf8')

# Change working directory, if necessary
dir = "D:\Sth\\twitter\mlusa"
os.chdir(dir)

# Read the csv file that contains all tweets
text = pd.read_csv("tweets.csv")

# Convert the data frame to an appropriate type!
text['text'] = text['text'].apply(str)

# Extract the tweet texts
df = DataFrame(text.text)

# Drop special characters (keep only English and Chinese characters)
# Adapted from http://stackoverflow.com/questions/2718196/find-all-chinese-text-in-a-string-using-python-and-regex
l = []
for i in range(len(df)):
    for n in re.findall(ur'[a-z|A-Z]+|[\u4e00-\u9fff]+',df.ix[i].to_string()[4:].lstrip()):
        l.append(n)
        print n

# Output
np.savetxt("tweets_2.csv", l, delimiter=",", fmt='%s')