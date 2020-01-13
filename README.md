# NGS reports
Advanced Rmarkdown templates for generating Next Generation Sequencing reports. The reports are stand alone, interactive html documents which include various quality metrics about the fastq reads and the mapping of the reads to the reference genome.

## Usage   
Clone this repository with
```
git clone https://github.com/angelovangel/ngs-reports.git
```
Open the respective Rmarkdown file in RStudio and click on `Knit` then `Knit with parameters`. Fill in the required fields and then press the `Knit` button. The generated report is a standalone html page with the same name as the Rmarkdown file, e.g. 02-RNAseq.Rmd will generate 02-RNAseq.html.    
## Requirements   
The required `R` packages will be installed if they are not available when you first run the pipeline. In addition, these external programs have to be available in your path:   

- [`GNU parallel`](https://www.gnu.org/software/parallel/)
- [`seqkit`](https://github.com/shenwei356/seqkit)
- [`samtools`](http://www.htslib.org/)
- [`RSeqQC`](http://rseqc.sourceforge.net/#)
- [`gffread`]()
- [`qualimap`]()

You can also use the `environment.yml` file to create a conda environment with the required tools:
```
conda env create -f environment.yml
```

and then activate it with:
```
conda activate ngs-reports-0.1
```


***

## FASTQ report
This template generates some quality metrics about a bunch of fastq files - total output, number of reads, percent of bases with a phred score > than Q20 and Q30, GC-content.

***


## RNAseq report   
In addition to the FASTQ quality metrics, this template generates also: alignment quality of the reads to the reference genome, summarization metrics of the assignment of the reads to genome features, duplication rate, read strandness, gene body coverage.

***
