
cran_pkgs <- c(
  'tidyverse',
  'cowplot',
  'stringr',
  'markdown',
  'evaluate',
  'ggplot2',
  'knitr',
  'RMySQL',
  'BiocManager',
  'devtools',
  'ggalt',
  'ggrepel',
  'ggbeeswarm',
  'ggsci',
  'ggalt',
  'foreach',
  'doParallel',
  'pROC',
  'Rtsne',
  'TCGA2STAT',
  'rbenchmark',
  'devtools',
  'remotes'
)

ip <- installed.packages()
cran_pkgs <- cran_pkgs[!(cran_pkgs %in% rownames(ip))]

install.packages(cran_pkgs, dependencies = TRUE)


