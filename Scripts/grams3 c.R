# loading functions 

library (data.table)

##########



# reloading training data
grams3<-readRDS(file = file.path("ngram model","grams3.rds"))

s<-Sys.time()

## Inner-Join grams3 with gram

grams2<-readRDS(file.path("ngram model","grams2.rds"))

options(datatable.nomatch=0)
setkey(grams2, terms)


setkey(grams3, term12)
grams3<-grams3[grams2
               ][,.(freq, term1, term2, term3)]

saveRDS(grams3 ,file = file.path("ngram model","grams3.rds"),compress = FALSE)


e<-Sys.time()

print(e-s)

warning("grams 3 c ready")

rm(list = ls())
.rs.restartR(afterRestartCommand = source("grams3 d.R"))
