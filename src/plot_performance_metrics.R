#!/usr/bin/env Rscript

## script for quickly plotting performance metrics from multiple runs

args = commandArgs(trailingOnly=TRUE)

outnames=gsub(".summary.csv","",args[1:length(args)-1])
outnames=gsub(".stats.csv","",outnames)
outnames=gsub("../callsets_performance/","",outnames)
outnames=gsub("_som_py","",outnames)


labeloutnames=outnames

outname=paste(outnames, collapse="_")


SNVP=matrix(nrow=length(args)-1,ncol=1)
SNVR=matrix(nrow=length(args)-1,ncol=1)
SVP=matrix(nrow=length(args)-1,ncol=1)
SVR=matrix(nrow=length(args)-1,ncol=1)

for(i in 1:(length(args)-1)){
d=read.table(args[i], header=TRUE, stringsAsFactors=FALSE, sep=",")
print(d)
    if("METRIC.Precision" %in% colnames(d)){
    SNVP[i,1]=d$METRIC.Precision[4]
    SNVR[i,1]=d$METRIC.Recall[4]
    SVP[i,1]=d$METRIC.Precision[2]
    SVR[i,1]=d$METRIC.Recall[2]
}
else if("precision" %in% colnames(d)){
    SNVP[i,1]=d$precision[2]
    SNVR[i,1]=d$recall[2]
    SVR[i,1]=d$recall[1]
    SVP[i,1]=d$precision[1]
}
}
print(SVR)
print(outnames)
png(paste0("../figures/",outname,".png"), width=1400, height=960)
par(mfrow=c(1,2), oma = c(0, 0, 10, 0))
par(mar = c(22.1, 4.3, 10.3, 17.3), lwd = 2, cex.axis = 1.4)


bp=barplot(cbind(SNVR,SNVP), beside=TRUE , col=c(rep("deepskyblue1",length(args)-1),rep("firebrick1",length(args)-1)), ylim=c(0,1.19), xaxs = "i", yaxs = "i" , space=c(0, 0.5), xlab="")
text(c(seq(1, (length(args)-1), by = 1),seq((length(args)-1)+1.5, ((length(args)-1)*2)+0.5, by = 1)) , par("usr")[3]-0.025,  srt = 315, adj = 0, xpd = TRUE, labels = rep(labeloutnames,2), cex = 1.1)
par(new=T)
mtext(args[length(args)], outer = TRUE, cex = 2.5, side=3)

title(main="SNVs", cex.main=1.6)
text(bp,cbind(SNVR, SNVP)+0.10, format(round(cbind(SNVR,SNVP),4), nsmall=4), cex=1.2, srt=270)

    bp=barplot(cbind(SVR,SVP), beside=TRUE , col=c(rep("deepskyblue1",length(args)-1),rep("firebrick1",length(args))), ylim=c(0,1.19), xaxs = "i", yaxs = "i" , space=c(0, 0.5), xlab="")
    text(c(seq(1, (length(args)-1), by = 1),seq((length(args)-1)+1.5, ((length(args)-1)*2)+0.5, by = 1)) , par("usr")[3]-0.025,  srt = 315, adj = 0, xpd = TRUE, labels = rep(labeloutnames,2), cex = 1.1)
title(main="INDELs", cex.main=1.6)
    text(bp,cbind(SVR, SVP)+0.10, format(round(cbind(SVR,SVP),4), nsmall=4), cex=1.2, srt=270)

dev.off()
quit()
