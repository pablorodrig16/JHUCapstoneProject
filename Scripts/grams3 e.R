# loading functions 

library (data.table)

options(datatable.nomatch = 0)
##########

# reloading training data
s<-Sys.time()

grams1<-readRDS(file = file.path("ngram model","grams1.rds"))
grams3<-readRDS(file = file.path("ngram model","grams3.rds"))
setkey(grams3,term2,term1)

##KN smoothing

Pcont<-grams3[,.N,by=term3]

grams2<-grams3[,sum(freq),by=list(term2,term3)][,.(term2,term3,freq=V1)][order(-freq)]

# Calculating KN smoothing
## lambda
d<-0.75

bi<-grams2[,.N]
tri<-grams3[,.N]
V<-Pcont[,.N]


## lambdas
bigrams<-grams2[,.(types=.N, tokens=sum(freq)),by=term2
                ][,lambda:=(d*types)/bi]

setkey(bigrams,term2)
setkey(grams2,term2)
grams2<-grams2[bigrams]


trigrams<-grams3[,.(types=.N, tokens=sum(freq)),by=list(term1,term2)
                 ][,lambda:=(d*types)/tri]
setkey(trigrams,term2,term1)
setkey(grams3,term2,term1)
grams3<-grams3[trigrams]

## Pcont and kn smoothing

#unigrams
Pcont<-Pcont[,Pkn1:=((N-d)/sum(N))+ (d/sum(N))]

#bigrams
setkey(Pcont,term3)
setkey(grams2,term3)
grams2<-grams2[Pcont]

grams2<-grams2[,Pkn2:=((freq-d)/tokens)+ exp(log(lambda) + log(Pkn1))][,.(term2,term3,freq,Pkn2)]

#trigrams
setkey(grams2,term3, term2)
setkey(grams3,term3,term2)
grams3<-grams3[grams2]

grams3<-grams3[,Pkn3:=((freq-d)/tokens)+ exp(log(lambda) + log(Pkn2))]


# final output
grams3<-grams3[,.(term1, term2, term3, freq, Pkn3)]
grams2<-grams2[,.(term2,term3,freq,Pkn2)]
Pcont<-Pcont[,.(term3, freq=N, Pkn1)]
grams1<-grams1[,.(terms,index)]

saveRDS(grams3 ,file = file.path("ngram model","grams3.rds"), compress = FALSE)
saveRDS(grams2 ,file = file.path("ngram model","grams2.rds"), compress = FALSE)
saveRDS(Pcont ,file = file.path("ngram model","Pcont.rds"), compress = FALSE)
saveRDS(grams1 ,file = file.path("ngram model","grams1.rds"), compress = FALSE)


e<-Sys.time()

print(e-s)

warning("End of processing")

rm(list = ls())
.rs.restartR()