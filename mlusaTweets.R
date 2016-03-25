# Set working directory
setwd("D:/Sth/twitter/mlusa")

# libraries
library("jiebaR")
library(tm)
library(tmcn)
library(lda)
library(LDAvis)
library(servr)

# Read in the data!
tweets <- read.csv("tweets.csv", sep = ",", header = T, fill = T, stringsAsFactors=FALSE, 
                   encoding="UTF-8")

# Overview (it doesn't matter... we care about the text anyways)
summary(tweets)

# Extract the tweets (in Python)
# write.csv(tweets$text, file = "mlusa_text.csv", append = FALSE, sep = ",",
#             eol = "\n", na = "NA", dec = ".", row.names = FALSE,
#             col.names = TRUE, fileEncoding = "UTF-8")
# write.csv(tweets$text, file = "mlusa_text.csv",row.names=FALSE, na="NA",
#             col.names="tweet_text", sep=",", fileEncoding = "UTF-8")

# read in the pure tweet text file
# text = read.table("mlusa_text.csv", header=T, sep=",", stringsAsFactors=FALSE)

# Set locale (reset later)
Sys.setlocale(locale="Chinese")

##  Run the cutter engine with the default setting  
mixseg = worker()
# with stopwords?
seg = worker(stop_word = "./stopword.txt")

# Auto segment words in the csv file. Output file saved under the same folder as well.
mixseg <= "./Tweet_text.csv"
seg <= "./tweets_2.csv"

mixseg   ### check the output of worker

#################
#
# LDA model below
#
#################
tweets_segged<- readLines("./Tweet_text.segment.2016-03-22_23_35_58.csv",encoding="UTF-8")
# the version with the stop words (based on the past 3w+ tweets)
tweets_segged<- readLines("./tweets_2.segment.2016-03-24_20_06_08.csv",encoding="UTF-8")
t <- as.list(tweets_segged) # turn the vector into a list
doc.list <- strsplit(as.character(t),split=" ") # split the list by space

term.table <- table(unlist(doc.list)) 
term.table <- sort(term.table, decreasing = TRUE)

# remove single character as well as words that occurred less than 5 times
del <- term.table < 5| nchar(names(term.table))<2   
term.table <- term.table[!del] 
# make a dictionary
vocab <- names(term.table)   

# get terms function. Thxs tanhe! link: http://computational-communication.com/2015/12/ldavis/
get.terms <- function(x) {
  index <- match(x, vocab)  # get words ID
  index <- index[!is.na(index)]  #remove the words that were already removed ahead
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))   #lda matrix structure
}
documents <- lapply(doc.list, get.terms)

# parameters settings for LDA
K <- 5   #number of topics
G <- 5000    #number of iterations
alpha <- 0.10   
eta <- 0.02

# Run LDA
set.seed(816816) 
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, num.iterations = G, 
                                   alpha = alpha, eta = eta, initial = NULL, burnin = 0, 
                                   compute.log.likelihood = TRUE)

# visualization
theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))  # document term matrix
phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))  # topic word matrix
term.frequency <- as.integer(term.table)   # frequency
doc.length <- sapply(documents, function(x) sum(x[2, ])) # wordcount


json <- createJSON(phi = phi, theta = theta, 
                   doc.length = doc.length, vocab = vocab,
                   term.frequency = term.frequency)
#json为作图需要数据，下面用servis生产html文件，通过out.dir设置保存位置
serVis(json, out.dir = './vis_stopword', open.browser = FALSE)

# change the encoding of the json file
writeLines(iconv(readLines("./vis_stopword/lda.json"), from = "GBK", to = "UTF8"), 
           file("./vis/lda.json", encoding="UTF-8"))

#################
#
# wordcloud
#
#################
# link: http://hoyoung.net/2016/01/04/R%E8%AF%AD%E8%A8%80%E5%88%86%E8%AF%8D%E5%8F%91%E5%B9%B6%E7%BB%98%E5%88%B6%E8%AF%8D%E4%BA%91/

# refresh locale setting
Sys.setlocale(category = "LC_ALL",locale="Chinese")

# read in the tweets
text = read.csv("Tweet_text.csv", encoding = "UTF-8", header=T, 
                  sep = '\n',stringsAsFactors=FALSE)
# somehow tweets are concat together... but it's fine.
tail(text)

# new seg
mixseg2 = worker(type = "mix", stop_word = "./stopword.txt")

# store the seg result
doc_all=c()


# set the locale back to English
Sys.setlocale(category = "LC_ALL",locale="English")


