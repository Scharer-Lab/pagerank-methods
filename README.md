## PageRank analysis using Taiji pipeline  

Two versions of Taiji pipeline are installed on both GRAID and GRAID2 server. Their command line names are taiji and taiji_new respectively.

On ESB, only 1 version is installed (version 1.2.1.3).

To run PageRank using Taiji, you must use the scripts in this bitbucket to create the input file, `input.yml`.

* Copy `config.yml` and `format_taiji.R` to your project's directory
* Edit the necessary fields in `config.yml`: output_dir, genome, annotation, motif_file and bwa_index. The options are listed above the field in a comment if necessary.
* Edit the necessary fields for `format_taiji.R`. Necessary fields are marked with a `# Replace` comment.
* Run `Rscript format_taiji.R`. This will make the necessary `input.yml` file. Note that group names in RNAseq and ATACseq must match exactly for this to work.
* Check the log file if it exists and make sure that there were no issues creating `input.yml`.
* Then, run Taiji. The command to run Taiji is one of these commands:
```
taiji run --config config.yml     # ESB and GRAID
taiji_new run --config config.yml # Just GRAID
```
* The pagerank output is in `output_dir/GeneRanks.tsv`. Note that results for each group are duplicated for each sample and should be removed.
* For analysis, any value below 10^-5 can be omitted.

### taiji (version 0.2.0)
* Uses bam files for ATAC and rpkm tables for RNA as input
* Example config and input files in taiji-0.2.0-formatting folder
* cisBP motif database files in taiji-0.2.0-formatting folder
* Script to create input.yml file from ESB manifest table

### taiji_new (version 1.0.1)
* Uses narrowPeaks files for ATAC and rpkm tables for RNA as input
* Example config and input files in taiji-1.0.1-formatting folder
* cisBP motif database files in taiji-1.0.1-formatting folder
* Script to create input.yml file from old ESB manifest table

### taiji (version 1.2.1.3)
* Uses narrowPeaks files for ATAC and rpkm tables for RNA as input
* Example config in taiji-1.2.1.3-formatting folder
* cisBP motif database files in taiji-1.2.1.3-formatting folder
* Script to create input.yml file from manifest file
* `-n` option for parallel processing is broken, do not use

### Reference
* Zhang, K., Wang, M., Zhao, Y., & Wang, W. (2019). Taiji: System-level identification of key transcription factors reveals transcriptional waves in mouse embryonic development. Science advances, 5(3), eaav3262.

