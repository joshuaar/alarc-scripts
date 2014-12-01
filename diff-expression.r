#!/usr/bin/Rscript
require(edgeR)
args=commandArgs()
args=args[6:length(args)]
x=read.csv(args[1],stringsAsFactors=F, row.names=1)
group = as.factor(read.csv(args[2],header=F)[,1])

y=DGEList(counts=x,group=group)
y=calcNormFactors(y)
y=estimateCommonDisp(y)
y=estimateTagwiseDisp(y)
et=exactTest(y)

pvals=et$table[,3]
pvals.correct=p.adjust(pvals,method="BH")

pvals.table=cbind(pvals,pvals.correct)
rownames(pvals.table)=rownames(x)
colnames(pvals.table)=c("P_Value","P_Value_FDR")

write.csv(pvals.table,"diff_expression.csv")
print("Saved differential expression results to diff_expression.csv")
