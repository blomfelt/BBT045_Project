#Project BBT045 - Applied Bioinformatics

# Read txt file -----------------------------------------------------------

setwd("~/Chalmers/Master 2023_2024/BBT045 Applied Bioinformatics/Project R script")

species_df = read.table("pca_data.txt", header=TRUE, row.names=1)
tspecies_df=t(species_df)

# PCA ---------------------------------------------------------------------

pca=prcomp(t(tspecies_df))
pcax=pca$x
summary(pca)

#colnames(tspecies_df)[1]="ds_1.5km_2012"

column.cols = c("orange","orange","orange", "orange","darkblue", "purple","purple","purple")[1:8]

#plot(pcax[,1],pcax[,2],col=column.cols, , pch=15,xlab="PC1", ylab="PC2")

plot(pcax[,1],pcax[,2],col=column.cols, , pch=15,xlab="PC1", ylab="PC2", xlim=c(-60,80), ylim=c(-25,40))

legend("topleft",col=c("orange", "darkblue" ,"purple"),legend=c("Downstream", "Effluent","Upstream"),pch=15)

text(pcax[,1],pcax[,2],labels=colnames(tspecies_df), pos=4)

