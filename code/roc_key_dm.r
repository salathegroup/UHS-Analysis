setEPS();
postscript("key_dm_roc.eps")
#par(cex.lab=2)
Sys.setenv(NOAWT=1)

library("RWeka")

files = c("../data/private/roc_keyword_dm_10_j48.arff","../data/private/roc_keyword_dm_10_logistic.arff","../data/private/roc_keyword_dm_10_naivebayes.arff","../data/private/roc_keyword_dm_10_randomforest.arff","../data/private/roc_keyword_dm_10_smo.arff","../data/private/roc_keyword_dm_100_j48.arff","../data/private/roc_keyword_dm_100_logistic.arff","../data/private/roc_keyword_dm_100_naivebayes.arff","../data/private/roc_keyword_dm_100_randomforest.arff","../data/private/roc_keyword_dm_100_smo.arff","../data/private/roc_keyword_dm_1000_j48.arff","../data/private/roc_keyword_dm_1000_logistic.arff","../data/private/roc_keyword_dm_1000_naivebayes.arff","../data/private/roc_keyword_dm_1000_randomforest.arff","../data/private/roc_keyword_dm_1000_smo.arff")

colors = c("red","blue","green","orange","purple")
colors = c(colors,colors,colors)

linetype = c(1,1,1,1,1,2,2,2,2,2,3,3,3,3,3)

plot(c(0,1),c(0,1),lty=2, xlim=c(0,1),ylim=c(0,1),type="l", xlab = NA, ylab = NA)

mtext("False Positives",1, cex=2,line=3)
mtext("True Positives",2,cex=2,line=2.5)
mtext("B",3,line=-2,cex=4,at=-.16)

for(x in 1:length(files))
{
 read.arff(files[x]) -> r
make.names(names(r)) -> names(r)

lines(r$False.Positives/max(r$False.Positives),r$True.Positives/max(r$True.Positives), type="l", col=colors[x], lwd=4, lty = linetype[x])
}

dev.off()
