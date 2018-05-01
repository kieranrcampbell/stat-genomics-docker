FROM rocker/rstudio:3.5.0

LABEL author="kieranrcampbell"

# Install tree
RUN apt-get update && apt-get install -y tree

# Install java
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated software-properties-common && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated oracle-java8-installer && \
    apt-get install -y --allow-unauthenticated oracle-java8-set-default

# Install pip
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://bootstrap.pypa.io/get-pip.py -o /opt/get-pip.py && \
    python /opt/get-pip.py && \
    rm /opt/get-pip.py

# Install core R dependencies
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'https://ftp.acc.umu.se/mirror/CRAN/'; options(repos = r);" > ~/.Rprofile && \
    Rscript -e "install.packages('tidyverse',dependencies=TRUE)" && \
    Rscript -e "install.packages('cowplot',dependencies=TRUE)" && \
    Rscript -e "install.packages('utils',dependencies=TRUE)" && \
    Rscript -e "install.packages('stringr',dependencies=TRUE)" && \
    Rscript -e "install.packages('markdown',dependencies=TRUE)" && \
    Rscript -e "install.packages('evaluate',dependencies=TRUE)" && \
    Rscript -e "install.packages('ggplot2',dependencies=TRUE)" && \
    Rscript -e "install.packages('knitr',dependencies=TRUE)" && \
    Rscript -e "install.packages('RMySQL',dependencies=TRUE)"

RUN apt-get update && \
    apt-get install -y zlib1g-dev

RUN Rscript -e "source('https://bioconductor.org/biocLite.R');biocLite();  biocLite(c('Biobase', 'GenomicRanges'))"

# Install R Bioconductor packages
RUN echo "source('https://bioconductor.org/biocLite.R')" > /opt/packages.r && \
    echo "biocLite();" >> /opt/packages.r && \
    echo 'biocLite(c("Biostrings", "XVector", "SingleCellExperiment", "Rsamtools", "ShortRead", "GenomicFeatures", "GenomicFeatures", "ensembldb", "scater", "biomaRt", "org.Hs.eg.db", "org.Mm.eg.db"))' >> /opt/packages.r && \
    Rscript /opt/packages.r

# Install R Bioconductor packages (2)
RUN echo 'source("https://bioconductor.org/biocLite.R")' > /opt/packages.r && \
    echo 'biocLite()' >> /opt/packages.r && \
    echo 'biocLite(c("scran"))' >> /opt/packages.r && \
    Rscript /opt/packages.r

RUN apt-get update && \
    apt-get install -y pkg-config libxml2-dev   

# Install R Bioconductor packages (3)
RUN echo 'source("https://bioconductor.org/biocLite.R")' > /opt/packages.r && \
    echo 'biocLite()' >> /opt/packages.r && \
    echo 'biocLite(c("fgsea", "reactome.db", "GSEABase"))' >> /opt/packages.r && \
    Rscript /opt/packages.r

# Install some extra R packages
RUN Rscript -e "install.packages('devtools', dependencies=TRUE)" && \
    Rscript -e "install.packages('ggalt', dependencies=TRUE)" && \
    Rscript -e "devtools::install_github('jeremystan/aargh')"

# Install snakemake

RUN apt-get update && apt install -y python3-pip && \
    pip3 install snakemake