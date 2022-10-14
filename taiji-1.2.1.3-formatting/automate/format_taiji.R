# Produce input.yml file to feed into the Taiji pipeline for PageRank

ATACProjectDir = "/ATACseq/PROJECT/DIR/" # Replace, must end with '/'
ATACmanFile = "pipeline/ATACseq.sample.manifest.txt" # Replace, if necessary
ATACmanifest = read.table(paste0(ATACProjectDir, ATACmanFile), header=T)
ATACmanifest = ATACmanifest[ATACmanifest$include, ]

RNAProjectDir = "/RNAseq/PROJECT/DIR/" # Replace, must end with '/'
RNAmanFile = "pipeline/RNAseq.sample.manifest.txt" # Replace, if necessary
RNAmanifest = read.table(paste0(RNAProjectDir, RNAmanFile), header=T, sep = '\t')
RNAmanifest = RNAmanifest[RNAmanifest$include, ]

experimentName = "" # Replace, input filename
expressionFile = paste0(RNAProjectDir, "coverage/", experimentName, ".geneRpkm.detected.RPM.3.exon.txt") # Replace, if necessary
expression = read.table(expressionFile, header = T, sep = "\t", as.is = T) # Note: Older projects may use csv instead of tsv

variableOfInterest = commandArgs(trailingOnly=TRUE)[1]

if (!all(RNAmanifest[, variableOfInterest] %in% ATACmanifest[, variableOfInterest])) { # Ensure everything matches, Taiji requires it
  print("Group names need to match to run Taiji PageRank. Exiting.")
  q()
}

outfile = paste0("input.", variableOfInterest, ".yml")

### ATACseq samples

write("ATAC-Seq:", outfile)

for(level in unique(ATACmanifest[, variableOfInterest])) { # TODO: paste(rep(" ", 3), collapse = "")
  write(paste0("  - id: ",level,"_ATAC"), outfile, append=T)
  write(paste0("    group: ",level), outfile, append=T)
  write(       "    replicates:", outfile, append=T)

  samples = which(ATACmanifest[, variableOfInterest]==level)
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

write("RNA-Seq:", outfile, append=TRUE)

for(level in unique(RNAmanifest[, variableOfInterest])){
  write(paste0("  - id: ", level, "_RNA"), outfile, append=T)
  write(paste0("    group: ", level), outfile, append=T)
  write(       "    replicates:", outfile, append=T)

  samples = which(RNAmanifest[, variableOfInterest]==level)
  for(i in 1:length(samples)){
    write(paste0("      - rep: ",i), outfile, append=T)
    write(       "        files:", outfile, append=T)

    # Make the needed tsv files for 'GeneQuant'
    sampleExpressionName = paste0(RNAmanifest$dir[samples[i]], RNAmanifest$sample[samples[i]], ".rpkm.tsv")

    # Ensure include column hasn't increased since RNAseq.coverage.R for this line
    sampleExpression = expression[, c("ENTREZID", paste0(RNAmanifest$sample[samples[i]], ".rpkm"))]
    write.table(file = sampleExpressionName, x = sampleExpression,
                col.names = F, row.names = F, quote = F, sep = '\t')


    write(paste0("          - path: ", sampleExpressionName), outfile, append=T)
    write(       "            tags: ['GeneQuant']", outfile, append=T)
  }
  write('', outfile, append=T)
}
