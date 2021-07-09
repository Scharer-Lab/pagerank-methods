files = read.table("/Volumes/GRAID2/Collaborations/T_cell/Tcell_Bulk_RNA/pipeline/ATACseq.sample.manifest.bulk.txt", header=T)
files = files[files$include,]

#write out ATAC seq samples for PageRank input.yml
outfile = "atac_input.yml"
write("ATAC-Seq:", outfile)

for(group in unique(files$group)){
  write(paste0("  - id: ",group,"_ATAC"), outfile, append=T)
  write(paste0("    group: ",group), outfile, append=T)
  write("    replicates:", outfile, append=T)

  samples = which(files$group==group)
  for(i in 1:length(samples)){
    fname = paste0(files$dir[samples[i]], files$bamFile[samples[i]])
    write(paste0("      - rep: ",i), outfile, append=T)
    write("        files:", outfile, append=T)
    write(paste0("          - path: ",fname), outfile, append=T)
    write('            tags: ["filtered"]', outfile, append=T)
  }
  write('', outfile, append=T)
}

#write out RNA seq samples for PageRank input.yml
files = read.table("/Volumes/GRAID2/Collaborations/T_cell/Tcell_Bulk_RNA/pipeline/RNAseq.sample.manifest.bulk.txt", header=T)
files = files[files$include,]

outfile = "rna_input.yml"
write("RNA-Seq:", outfile)

for(group in unique(files$group)){
  write(paste0("  - id: ",group,"_RNA"), outfile, append=T)
  write(paste0("    group: ",group), outfile, append=T)
  write("    replicates:", outfile, append=T)

  samples = which(files$group==group)
  for(i in 1:length(samples)){
    fname = paste0("/home/timi/Koff_lab/PageRank/rna/", files$sample[samples[i]], ".rpkm.tsv")
    write(paste0("      - rep: ",i), outfile, append=T)
    write("        files:", outfile, append=T)
    write(paste0("          - path: ",fname), outfile, append=T)
    write('            tags: ["gene quantification"]', outfile, append=T)
  }
  write('', outfile, append=T)
}
