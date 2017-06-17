# loading functions 

library(data.table)


#################

s<-Sys.time()

# reloading training data
grams2<-readRDS(file = file.path("ngram model","grams2.rds"))


## extracting terms 1 and 2 from bigrams
grams2<-grams2[,.(terms,
                  term1=sapply(strsplit(terms," "),function (x) x[1]),
                  term2=sapply(strsplit(terms," "),function (x) x[2]),
                  freq)]



## Inner-Join grams2 and grams1 data.tables 

grams1<-readRDS(file.path("ngram model","grams1.rds"))

options(datatable.nomatch=0)
setkey(grams1, terms)

setkey(grams2, term1)
grams2<-grams2[grams1,
               ][,.(terms, freq, term1=index, term2)]

setkey(grams2, term2)
grams2<-grams2[grams1,
               ][,.(terms, freq, term1, term2=index)]


# final output
grams2<-grams2[,.(terms, term1, term2, freq)]


## saving grams
e<-Sys.time()

saveRDS(grams2 ,file = file.path("ngram model","grams2.rds"),compress = FALSE)
print(e-s)

print("grams 2 ready")
rm(list = ls())
.rs.restartR(afterRestartCommand = source(file = "grams3.R"))
