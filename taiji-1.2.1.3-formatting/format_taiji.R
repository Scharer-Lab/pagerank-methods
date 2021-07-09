# Produce input.yml file to feed into the Taiji pipeline for PageRank

ATACProjectDir = "/PROJECT/DIR/" # Replace, must end with '/'
ATACmanFile = "pipeline/ATACseq.sample.manifest.txt" # Replace, if necessary
ATACmanifest = read.table(paste0(ATACseqProjectDir, ATACManFile), header=T)
ATACmanifest = ATACmanifest[ATACmanifest$include, ]

RNAProjectDir = "/PROJECT/DIR/" # Replace, must end with '/'
RNAmanFile = "pipeline/ATACseq.sample.manifest.txt" # Replace, if necessary
RNAmanifest = read.table(paste0(RNAProjectDir, RNAmanFile), header=T)
RNAmanifest = RNAmanifest[RNAmanifest$include, ]

experimentName = "" # Replace, input filename
expressionFile = paste0(RNAProjectDir, "coverage/", experimentName, ".geneRpkm.detected.RPM.3.exon.csv")
expression = read.table(expressionFile, header = T, sep = ",", as.is = T)

if (!all(RNAmanifest$group %in% ATACmanifest$group)) { # TODO: Does the order need to match?
  print("Group names need to match to run Taiji PageRank. Exiting.")
  q()
}

outfile = "input.yml"

### ATACseq samples

write("ATAC-Seq:", outfile)

for(group in unique(ATACmanifest$group)) { # TODO: paste(rep(" ", 3), collapse = "")
  write(paste0("  - id: ",group,"_ATAC"), outfile, append=T)
  write(paste0("    group: ",group), outfile, append=T)
  write(       "    replicates:", outfile, append=T)

  samples = which(ATACmanifest$comp==group)
  for(i in 1:length(samples)) {
    peakName = ATACmanifest$PeakFile[samples[i]]
    write(paste0("      - rep: ",i), outfile, append=T)
    write(       "        files:", outfile, append=T)
    write(paste0("          - path: ", peakName), outfile, append=T)
    write(       "            format: NarrowPeak", outfile, append=T)
  }
  write('', outfile, append=T)
}

### Matched RNAseq samples

write("RNA-Seq:", outfile)

for(group in unique(RNAmanifest$group)){
  write(paste0("  - id: ", group, "_RNA"), outfile, append=T)
  write(paste0("    group: ", group), outfile, append=T)
  write(       "    replicates:", outfile, append=T)

  samples = which(RNAmanifest$group==group)
  for(i in 1:length(samples)){
    write(paste0("      - rep: ",i), outfile, append=T)
    write(       "        files:", outfile, append=T)

    # Make the needed tsv files for 'GeneQuant'
    sampleExpressionName = paste0(RNAmanifest$dir[samples[i]], RNAmanifest$sample[samples[i]], ".rpkm.tsv")
    if (!file.exists(sampleExpressionName)) {
      # Ensure include column hasn't increased since RNAseq.coverage.R for this line
      sampleExpression = expression[, c("ENTREZID", paste0(RNAmanifest$sample[samples[i]], ".rpkm"))]
      write.table(file = sampleExpressionName, x = sampleExpression, 
                  col.names = F, row.names = F, quote = F, sep = '\t')
    }

    write(paste0("          - path: ", sampleExpressionName), outfile, append=T)
    write(       "            tags: ['GeneQuant']", outfile, append=T)
  }
  write('', outfile, append=T)
}
