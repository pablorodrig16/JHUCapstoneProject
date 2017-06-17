# loading functions 

source(file = "functions.R",echo = FALSE)

# Download docs
if (!dir.exists("Corpora")){
    dir.create("Corpora")
    download.file(url = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",
                  destfile = "Coursera-SwiftKey.zip")
    unzip(zipfile = "Coursera-SwiftKey.zip")
    file.remove("Coursera-SwiftKey.zip")
}

blogs<-readLines(file.path("Corpora","en_US","en_US.blogs.txt"),warn = FALSE, encoding = "UTF-8")
news<-readLines(file.path("Corpora","en_US","en_US.news.txt"), warn = FALSE, encoding = "UTF-8")
twitter<-readLines(file.path("Corpora","en_US","en_US.twitter.txt"),warn = FALSE, encoding = "UTF-8")

# sampling documents
set.seed(1000)
sblogs<-resampleTrainTest(blogs,prop = .3,ratio = .95)
snews<-resampleTrainTest(news,prop = .3,ratio = .95)
stwitter<-resampleTrainTest(twitter,prop = .3, ratio = .95)

rm (blogs,news, twitter)
#
blogstrain<-corpus(sblogs$train)
newstrain<-corpus(snews$train)+corpus(stwitter$train)
twittertrain<-corpus(stwitter$train)

if (!dir.exists("ngram model")){
    dir.create("ngram model")
}

saveRDS(blogstrain,file = file.path("ngram model","blogstrain.rds"))
saveRDS(newstrain,file = file.path("ngram model","newstrain.rds"))
saveRDS(twittertrain,file = file.path("ngram model","twittertrain.rds"))

blogstest<-corpus(sblogs$test)
newstest<-corpus(snews$test)+corpus(stwitter$test)
twittertest<-corpus(stwitter$test)

saveRDS(blogstest,file = file.path("ngram model","blogstest.rds"))
saveRDS(newstest,file = file.path("ngram model","newstest.rds"))
saveRDS(twittertest,file = file.path("ngram model","twittertest.rds"))

print("getting docs ready")
.rs.restartR(afterRestartCommand = source(file = "processing grams.R"))
