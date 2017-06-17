
#########

# loading functions 

library (data.table)


## reloads grams1 dfm
grams1<-readRDS(file = file.path("ngram model","grams1.rds"))

s<-Sys.time()

## removing terms with numbers and other special characters
grams1<-grams1[!grepl(pattern = "[^a-z\\-]",x = terms)|
                   !grepl(pattern = "[^a-z\\']",x = terms)|
                   grepl(pattern = "#[se]#",terms)]

## adding UNK term
grams1<-rbindlist(l = list(grams1, 
                           list(terms=c("<unk>"),
                                freq=c(0))))


# final output
grams1<-grams1[, .(terms, freq, index=1:.N)]


e<-Sys.time()

saveRDS(grams1 ,file = file.path("ngram model","grams1.rds"),compress = FALSE)
print(e-s)


print("grams 1 ready")
rm(list = ls())
.rs.restartR(afterRestartCommand = source(file = "grams2.R"))