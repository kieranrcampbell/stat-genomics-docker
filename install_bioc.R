bioc_pkgs <- c(
  'Biostrings', 
  'XVector', 
  'SingleCellExperiment',
  'Rsamtools', 
  'ShortRead', 
  'GenomicFeatures', 
  'ensembldb', 
  'scater',
  'org.Hs.eg.db', 
  'org.Mm.eg.db',
  'fgsea',
  'reactom.db',
  'GSEABase',
  'scran',
  'biomaRt',
  'TxDb.Hsapiens.UCSC.hg19.knownGene',
  'BiocParallel', 
  'goseq', 
  'edgeR', 
  'limma', 
  'BiocStyle', 
  'BiocCheck', 
  'SC3', 
  'iSEE', 
  'TxDb.Mmusculus.UCSC.mm9.knownGene', 
  'CNTools',
  'DropletUtils'
)


ip <- installed.packages()
bioc_pkgs <- bioc_pkgs[!(bioc_pkgs %in% rownames(ip))]

BiocManager::install(bioc_pkgs)


