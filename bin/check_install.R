# check if required packages are installed
# and install if needed
# check my clever way of checking

# INPUT - a character vector with packages
# OUTPUT - no output, side effects are installing and loading packages from the input

check_install <- function(PKGs, repo = "CRAN") {
  
  loadPKGs <- function(x) { 
    suppressPackageStartupMessages(library(x, character.only = TRUE)) 
    }

  check <- PKGs %in% installed.packages()
  
  # here is my invention
  if(sum(check) != length(PKGs)) {
    cat(
      "Some required packages are not installed on this machine. These are:", 
      PKGs[!check],
      "Will attempt to install and load now...", 
      sep = "\n")
  
    cat("Installing", PKGs[!check], sep = " ", "\n")
    if (repo == "Bioconductor") {
      require(BiocManager)
      BiocManager::install(PKGs, update = FALSE)  
    } else {
      install.packages(PKGs[!check], repos = "https://cloud.r-project.org")
    }
    invisible(lapply(PKGs, loadPKGs))
  } else {
    
    cat("The following packages were found on this machine and will be loaded:",
        PKGs[check], sep = "\n")
    
    invisible(lapply(PKGs, loadPKGs))
  }

}