# Tweet-analysis-with-topic-model

An experiment of applying topic model to a tweet archive, downloaded from the Twitter server (Settings -> Account -> Request Twitter Archive). The code is originally adapted from [Tan He](http://computational-communication.com/2015/12/ldavis/), where he demostrated how to analyze and visualize **Chinese text** using topic model. For more information about topic model, refer to links below (or google "Topic Models". I'm pretty sure there are plenty of awesome texts out there!):

[A topic model for movie reviews](http://cpsievert.github.io/LDAvis/reviews/reviews.html)

[Topic Model - Wikipedia](https://en.wikipedia.org/wiki/Topic_model)

[Topic Modeling: A Basic Introduction](http://journalofdigitalhumanities.org/2-1/topic-modeling-a-basic-introduction-by-megan-r-brett/)

## What tools/packages do I need?
* Tools:
  - Python 2.7.9
  - R 3.2.2
  - Notepad++ v 6.7.8 (or above)
* Packages:
  - in Python: Pandas, Numpy
  - in R: JiebaR, LDA, LDAvis, servr

## How to use the files here?
The repository contains three files: `LDATweets.R`, `stopword.txt`, and `tweetExtract.py`.
- `LDATweets.R`: the core file that runs the LDA model. 
- `stopword.txt` (optional): a plain text file containing main English and Chinese stopwords. Currently in utf-8 format; downloaded from [ibook360](http://www.cnblogs.com/ibook360/archive/2011/11/23/2260397.html). Please, substitute this with your favorite stopword list if you'd like!
- `tweetExtract.py`: preprocessing tweets before running the topic model.

Thus, it is recommended to run the files in the following order:
1. Request your Twitter Archive from [twitter.com](https://twitter.com).
2. Unzip your Twitter Archive to the local disk. You should find `tweets.csv` under the root.
  - Ideally, your tweets should be mostly **Chinese**. If it's in English, refer to [A topic model for movie reviews](http://cpsievert.github.io/LDAvis/reviews/reviews.html) as shwon above.
3. Make sure that `tweets.csv`, `LDATweets.R`, `tweetExtract.py`, and (optional) `stopword.txt` are all in your working directory.
4. Run `tweetExtract.py`.
5. Run `LDATweets.R`. It may take a while for R to execute the script, depending on the size of your tweet archive.
6. Open the `vis` folder, found under the root of your working directory.
  1. Create an empty file with whatever name you like, but the extension must be `.json`.
  2. Edit that file in Notepad++. Click on "Encoding" -> "Encode in UTF-8".
  3. Save the file.
  4. Open `lda.json`. Copy and paste everything in the `.json` file above.
  5. Save the `.json` file again. 
  6. Remove the `lda.json` file and renamed the previous `.json` file as `lda.json`.
  Step 6 is to force Chinese characters to correctly display in your browser.
7. Upload the whole `vis` folder to a server, or open the `index.html` in Firefox.
8. Enjoy!

## Questions?
Comment below or mention [@mlusa](https://twitter.com/mlusa) on Twitter.

I shall update the readme once I found out more information about Topic Model.


