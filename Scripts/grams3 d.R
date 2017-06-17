# loading functions 

library (data.table)

##########



# reloading training data
grams3<-readRDS(file = file.path("ngram model","grams3.rds"))

s<-Sys.time()

## Inner-Join grams3 with grams1 for term3

grams1<-readRDS(file.path("ngram model","grams1.rds"))
setkey(grams1, terms)
setkey(grams3, term3)
grams3<-grams3[grams1
               ][,.(freq, term1, term2, term3= index)]
grams3<-grams3[!is.na(freq)]

saveRDS(grams3 ,file = file.path("ngram model","grams3.rds"),compress = FALSE)

e<-Sys.time()

print(e-s)

warning("grams 3 d ready")

rm(list = ls())
.rs.restartR(afterRestartCommand = source("grams3 e.R"))