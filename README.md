# NGS reports
Advanced Rmarkdown templates for generating NGS reports.   
## Usage   
Clone this repository with
```
git clone https://github.com/angelovangel/ngs-reports.git
```
Open the respective Rmarkdown file in RStudio and click on `Knit` then `Knit with parameters`. Fill in the required fields and then press the `Knit` button. The generated report is a standalone html page with the same name as the Rmarkdown file, e.g. 02-RNAseq.Rmd will generate 02-RNAseq.html.    
## Requirements   
The required `R` packages will be installed if they are not available when you first run the pipeline. In addition, these external programs have to be available in your path:   
- [`seqkit`]()
- [`GNU parallel`]()



***


## RNAseq report   
This template is
