## PageRank analysis using Taiji pipeline  

Two versions of Taiji pipeline are installed on both GRAID and GRAID2 server. Their command line names are taiji and taiji_new respectively.  

The command to run Taiji is:
```
taiji run --config config.yml
taiji_new run --config config.yml
```

### taiji (version 0.2.0)
* Uses bam files for ATAC and rpkm tables for RNA as input
* Example config and input files in older_version folder
* cisBP motif database files in older_version folder
* Script to create input.yml file from ESB manifest table

### taiji_new (version 1.0.1)
* Uses narrowPeaks files for ATAC and rpkm tables for RNA as input
* Example config and input files in current_version folder
* cisBP motif database files in current_version folder
* Script to create input.yml file from ESB manifest table

### Reference
* Zhang, K., Wang, M., Zhao, Y., & Wang, W. (2019). Taiji: System-level identification of key transcription factors reveals transcriptional waves in mouse embryonic development. Science advances, 5(3), eaav3262.