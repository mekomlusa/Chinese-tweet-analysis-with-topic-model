# Set working directory
setwd("SET YOUR WORKING DIRECTORY HERE")

# libraries
# to install missing libaries: use the commented line below
# install.library("LIBRARY NAME HERE")
library(jiebaR)
library(lda)
library(LDAvis)
library(servr)

# Set locale (reset later). If your locale is already in Chinese, neglect it.
Sys.setlocale(category="LC_ALL",locale="Chinese")

##  Run the cutter engine with stopword
seg = worker(stop_word = "./stopword.txt")

# Auto segment words in the csv file. Output file saved under the same folder as well.
# Substitute "tweet.csv" to the name of your pre-processed tweet file
seg <= "./tweets_2.csv"
# Output from the R console: >[1] "./tweets_2.segment.2016-03-24_20_06_08.csv"

seg   ### check the setting of worker

#################
#
# LDA model 
#
#################
# Substitute the csv path below - i.e. copy and pasted the output from the R console as shown on line 21.
tweets_segged<- readLines("./tweets_2.segment.2016-03-24_20_06_08.csv",encoding="UTF-8")
t <- as.list(tweets_segged) # turn the vector into a list
doc.list <- strsplit(as.character(t),split=" ") # split the list by space

term.table <- table(unlist(doc.list)) 
term.table <- sort(term.table, decreasing = TRUE)

# remove single character as well as words that occurred less than 5 times
del <- term.table < 5| nchar(names(term.table))<2   
term.table <- term.table[!del] 

# make a vocabulary list.
vocab <- names(term.table)   

# get terms function. Thxs Tanhe! link: http://computational-communication.com/2015/12/ldavis/
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

# Run LDA. Change seed if you'd like.
set.seed(816816) 
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = K, vocab = vocab, num.iterations = G, 
                                   alpha = alpha, eta = eta, initial = NULL, burnin = 0, 
                                   compute.log.likelihood = TRUE)
                                   
# Some interesting features provided by the LDA package
# Predict new words for the document
predictions <- predictive.distribution(fit$document_sums, fit$topics,
                                       0.1, 0.1)
# Use top.topic.words to show the top 5 predictions in each document.
top.topic.words(t(predictions), 5)

# wordcloud
library(wordcloud)
library(RColorBrewer)
pal <- brewer.pal(8,"Dark2")
wordcloud(vocab,term.table,scale=c(4,.5),min.freq=200,max.words=Inf, random.order=FALSE, colors=pal)

# visualization
theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))  # document term matrix
phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))  # topic word matrix
term.frequency <- as.integer(term.table)   # frequency
doc.length <- sapply(documents, function(x) sum(x[2, ])) # wordcount

# Create json file from the fit (from LDAvis)
json <- createJSON(phi = phi, theta = theta, 
                   doc.length = doc.length, vocab = vocab,
                   term.frequency = term.frequency)
# Write out the json file to a local directory using the serVis function from LDAvis
serVis(json, out.dir = './vis', open.browser = FALSE)

# change the encoding of the json file
writeLines(iconv(readLines("./vis/lda.json"), from = "GBK", to = "UTF8"), 
           file("./vis/lda.json", encoding="UTF-8"))

# Reset locale
Sys.setlocale(category="LC_ALL",locale="English")


