# loading functions 

library(data.table)

##########



# reloading training data
grams3<-readRDS(file = file.path("ngram model","grams3.rds"))

s<-Sys.time()


## extracting terms 1+2 and 3 from trigrams
grams3<-grams3[,.(terms,
                  term12,
                  term3=sapply(strsplit(terms," "),function (x) x[3]),
                  freq)]


grams3<-grams3[,.(term12,term3,freq)]
saveRDS(grams3 ,file = file.path("ngram model","grams3.rds"))

e<-Sys.time()

print(e-s)

warning("grams 3 b ready")
rm(list = ls())
.rs.restartR(afterRestartCommand = source("grams3 c.R"))