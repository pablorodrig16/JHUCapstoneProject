source(file = "functions.R",echo = FALSE)

files<-c("blogstest.rds","newstest.rds","twittertest.rds","blogstrain.rds","newstrain.rds","twittertrain.rds")


for (f in files){
    trainCorpus<-readRDS(file.path("ngram model",f))
    
    for (n in 1:3)
    {
        ## Creation of a dfm
        grams<-parallelFUN(FUN = dfms, sent = trainCorpus, n = n)
        
        ## Creation of a data.table with terms frequency
        grams<-data.table(terms=featnames(grams),freq=as.integer(colSums(grams)))
        
        ## file name
        fileName<-paste("grams",n,f, sep="_")
        
        ## saving
        saveRDS(grams ,file = file.path("ngram model",fileName))
        
    }
}


print("processing grams b ready")
.rs.restartR(afterRestartCommand = source(file = "ngram datatables.R"))
