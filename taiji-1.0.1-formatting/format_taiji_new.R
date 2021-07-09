files = read.table("/home/timi/Koff_lab/Koff_ATAC/pipeline/ATACseq.sample.manifest.withFRiP.txt", header=T)
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
    #fname = paste0(files$dir[samples[i]], files$bamFile[samples[i]])
    fname = files$PeakFile[samples[i]]
    write(paste0("      - rep: ",i), outfile, append=T)
    write("        files:", outfile, append=T)
    write(paste0("          - path: ",fname), outfile, append=T)
    write('            format: NarrowPeak', outfile, append=T)
  }
  write('', outfile, append=T)
}

#write out RNA seq samples for PageRank input.yml
files = read.table("/Volumes/ESB/Collaborations/Byron_AuYeung/CD4_subsets/CD4_subsets_RNA/pipeline/RNAseq.sample.manifest2.txt", header=T)
files = files[files$include,]

outfile = "rna_input.yml"
write("RNA-Seq:", outfile)

for(group in unique(files$group)){
  write(paste0("  - id: ",group,"_RNA"), outfile, append=T)
  write(paste0("    group: ",group), outfile, append=T)
  write("    replicates:", outfile, append=T)

  samples = which(files$group==group)
  for(i in 1:length(samples)){
    fname = paste0("/Volumes/ESB/Collaborations/Byron_AuYeung/CD4_subsets/PageRank/rna/", files$sample[samples[i]], ".rpkm.tsv")
    write(paste0("      - rep: ",i), outfile, append=T)
    write("        files:", outfile, append=T)
    write(paste0("          - path: ",fname), outfile, append=T)
    write("            tags: ['GeneQuant']", outfile, append=T)
  }
  write('', outfile, append=T)
}
