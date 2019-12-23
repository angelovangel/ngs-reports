# defines 2 functions - to read samplesheet and to format samplesheet after reading

# readsamplesheet() reads the standard xls NCCT sample sheet and
# returns a html formatted df for kableExtra
# example sample sheet: NCCT_Mibi_Sample_InputQC_v1Nov2019.xlsx

# formatsamplesheet() formats the output of readsamplesheet() for pretty printing

require(readr)
require(dplyr)
require(kableExtra)

readsamplesheet <- function(samplesheet) {
    read_excel(samplesheet,
                     sheet = 1,
                     range = cell_limits(ul = c(18, 2), lr = c(NA, NA))) %>%
    select(sample_name = `Sample name`, c(8:11)) %>%
    mutate(
      nanodrop.ng.ul = cell_spec(nanodrop.ng.ul, "html", color = "black"),
      qbit.ng.ul = cell_spec(qbit.ng.ul, "html", color = "black"),
      ratio.260.280 = cell_spec(
        ratio.260.280,
        "html",
        color = case_when(
          ratio.260.280 < 1.5 ~ "red",
          ratio.260.280 <= 1.7 ~ "orange",
          ratio.260.280 > 1.7 ~ "black"
        )
      ),
      
      ratio.260.230 = cell_spec(
        ratio.260.230,
        "html",
        color = case_when(
          ratio.260.230 < 1.5 ~ "red",
          ratio.260.230 <= 1.7 ~ "orange",
          ratio.260.230 > 1.7 ~ "black"
        )
      )
    )
}

formatsamplesheet <- function(samplesheet) {
  samplesheet %>%
    kable(
      format = "html",
      escape = FALSE,
      col.names = c(
        "Sample",
        "Nanodrop ng/µl",
        "260/280",
        "260/230",
        "Qubit ng/µl"
      ),
      align = "lrrrr",
      caption = "Sample measurements at NCCT"
    ) %>%
    kable_styling(bootstrap_options = c("condensed", "hover"),
                  full_width = T) %>%
    row_spec(0,
             bold = T,
             color = "black",
             background = "#e6f0ff")
}

