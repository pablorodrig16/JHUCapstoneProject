## loading functions


source(file = "functions.R",echo = FALSE)


## reading corpus
files<-c("blogstest.rds","newstest.rds","twittertest.rds","blogstrain.rds","newstrain.rds","twittertrain.rds")


## tokenizing in sentences and adding start and end tags
for (f in files){
    trainCorpus<-readRDS(file.path("ngram model",f))
    
    ## tokenkize trainCorpus as sentences and add start and end marks
    trainCorpus<-parallelFUN(FUN = sent, trainCorpus)
    saveRDS(trainCorpus,file = file.path("ngram model",f))
}

print ("processing grams ready")
.rs.restartR(afterRestartCommand = source(file = "processing grams 2.R"))
