## Functions for data processing
## 

# Cleaning memory

rm (list = ls())
gc()

# loading libraries
library (doParallel)
library(data.table)
library (quanteda)


#function to get a list with train and test data as specified by ratio from
#a sampled vector (prop of x)
resampleTrainTest<-function (x, prop=0.2,ratio=0.8){
    l<-length (x)
    x<-x[sample(1:l,size = floor(l*prop),replace = FALSE)]
    l<-length (x)
    index<-((1:l)/l)<=ratio
    list (train=x[index],
          test=x[!index])
}

# function to do parallel processing
parallelFUN <- function(FUN, ...) {
    nc <- detectCores()
    clusters <- makeCluster(nc)
    registerDoParallel(clusters)
    result <- FUN(...)
    stopCluster(clusters)
    result
}

# replace UNK words
replaceUNK<-function (x, vocabulary=character(), split=" "){
    x<-tolower(x)
    words<-strsplit(x,split)
    words<-sapply(words, function (y) ifelse(y%in%vocabulary, y, "<unk>"))
    return (as.character(words))
}


replaceUNKword<-function (x, v=vocabulary$terms){
    x<-tolower(x)
    ifelse(x%in%v, x, "<unk>")
}

# The following functions use quanteda package
# tokenize in sentences 
sent<-function (cp){
    se<-tokens(cp, 
               what= "sentence",
               removePunct=TRUE,
               removeSymbols=TRUE,
               removeSeparators=TRUE, 
               removeTwitter=TRUE, 
               removeURL=TRUE)
    se<-paste("#s# #s# ",se," #e#",sep = "")
    return(se)
}

# tokenize in grams - the argument sent must be a text
ng<-function (sent,n){
    tokens(sent, 
           what="word",
           ngrams=n,
           concatenator=" ",
           removePunct = TRUE)
}

# creates datatables
dfms<-function (sent, n) {
    dfm(sent,
        ngrams=n,
        concatenator=" ",
        removePunct = TRUE, 
        tolower=TRUE)
}