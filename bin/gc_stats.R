# obtain GC statistics for a bunch of fastq files
# !! using qckitfastq in parallel in R !!
# 

# args - a vector with fastq file names and number of bins for which to calculate GC content 
# output - a dataframe with file names and GC content data per file
# 
# 
require(parallel)
require(qckitfastq)
require(dplyr)
require(purrr)
require(apexcharter)
require(ggplot2) # just for aes_()

gc_stats <- function(fastqfiles, breaks = 25) {
      # set names, needeed to get a named list from mclapply
    names(fastqfiles) <- basename(fastqfiles)

      # much faster with parallel, of course
    gcdata_hist <- parallel::mclapply(fastqfiles, qckitfastq::gc_per_read) %>% # gcdata is the named list
        # get the density for each file
        # !!! Just use hist(gcdata$JStest07_S7_R1_001.fastq.gz, plot = F, breaks = seq(0,1, by = 0.01)) - faster, and gives me counts
                    parallel::mclapply(hist, plot = F, breaks = breaks)
  
      # directly make a df and calculate percents 
    cbind(map_df(gcdata_hist, `[`, "mids", .id = "readname"), map_df(gcdata_hist, `[`, "counts")) %>%
      group_by(readname) %>% 
      mutate(percents = counts/sum(counts)*100)
}


# makes an apex line plot with the dataframe returned by gc_stats()
# NSE works fine with apexcharter!

gc_stats_apexplot <- function(gc_stats_df, x, y, group, width = "500", height = "500") {
  x_var <- enquo(x)
  y_var <- enquo(y)
  group_var <- enquo(group)
  
  gc_stats_df %>%
    apex(mapping = aes(x = !!x_var, y = !!y_var, group = !!group_var), 
         type = "line", 
         height = height, 
         width = width) %>% 
    ax_stroke(width = 1.5, curve = "smooth") %>% 
    ax_yaxis(decimalsInFloat = 0) %>% 
    ax_xaxis(tickAmount = 5) %>%
    ax_tooltip(
      enabled = TRUE, 
      shared = FALSE, 
      followCursor = TRUE, 
      x = list(show = TRUE)) %>%
    ax_grid(
      yaxis = list(lines = list(show = TRUE)),
      xaxis = list(lines = list(show = TRUE))
    )
}
  
  
