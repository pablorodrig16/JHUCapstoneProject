# loading functions 

library (data.table)

##########



# reloading training data
grams3<-readRDS(file = file.path("ngram model","grams3.rds"))

s<-Sys.time()


## extracting terms 1+2 and 3 from trigrams
grams3<-grams3[,.(terms,
                  term12=sapply(strsplit(terms," "),function (x) paste(x[1:2],collapse = " ")),
                  freq)]

saveRDS(grams3 ,file = file.path("ngram model","grams3.rds"))

e<-Sys.time()

print(e-s)

print ("grams3 a ready")

rm(list = ls())
.rs.restartR(afterRestartCommand = source("grams3 b.R"))