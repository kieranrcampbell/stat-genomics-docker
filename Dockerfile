FROM rocker/rstudio:3.5.0

LABEL author="kieranrcampbell"

# Install tree
RUN apt-get update && apt-get install -y tree

# Install java
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated software-properties-common && \
    # add-apt-repository ppa:webupd8team/java && \
    # apt-get update && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    apt-get install -y --allow-unauthenticated default-jdk

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
    echo 'biocLite(c("Biostrings", "XVector", "SingleCellExperiment", "Rsamtools", "ShortRead", "GenomicFeatures", "GenomicFeatures", "ensembldb", "scater", "org.Hs.eg.db", "org.Mm.eg.db"))' >> /opt/packages.r && \
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
    Rscript -e "devtools::install_github('jeremystan/aargh')" && \
    Rscript -e "devtools::install_github('MarioniLab/DropletUtils')"


# Install snakemake

RUN apt-get update && apt install -y python3-pip && \
    pip3 install snakemake

# Install R Bioconductor packages (2)
RUN echo 'source("https://bioconductor.org/biocLite.R")' > /opt/packages.r && \
    echo 'biocLite()' >> /opt/packages.r && \
    echo 'biocLite(c("scran", "biomaRt", "TxDb.Hsapiens.UCSC.hg19.knownGene"))' >> /opt/packages.r && \
    Rscript /opt/packages.r

# Install R Bioconductor packages (again)
RUN echo 'source("https://bioconductor.org/biocLite.R")' > /opt/packages.r && \
    echo 'biocLite()' >> /opt/packages.r && \
    echo 'biocLite(c("BiocParallel", "goseq", "edgeR", "limma", "BiocStyle", "BiocCheck", "SC3", "iSEE"))' >> /opt/packages.r && \
    Rscript /opt/packages.r && \
    Rscript -e "install.packages('ggrepel', dependencies=TRUE)" && \
    Rscript -e "install.packages('ggbeeswarm', dependencies=TRUE)" && \
    Rscript -e "install.packages('ggsci', dependencies=TRUE)" 

RUN apt-get update && \
    apt-get install -y emacs

# Install tensorflow for R

# First for root
RUN sudo apt-get install -y python-pip && \
    sudo python -m pip install virtualenv && \
    Rscript -e "install.packages('tensorflow');" && \
    Rscript -e "tensorflow::install_tensorflow()"

# Then for rstudio
RUN usermod -aG sudo rstudio && \
    echo "rstudio ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER rstudio
RUN sudo apt-get install -y python-pip && \
    sudo python -m pip install virtualenv && \
    Rscript -e "install.packages('tensorflow');" && \
    Rscript -e "tensorflow::install_tensorflow()"

USER root

# And install ggalt

RUN apt-get update && \
    apt-get install -y libgdal-dev libproj-dev && \
    Rscript -e "install.packages('ggalt', dependencies=TRUE)" && \
    Rscript -e "install.packages('foreach', dependencies=TRUE)" && \
    Rscript -e "install.packages('doParallel', dependencies=TRUE)"

RUN Rscript -e "install.packages('tidyverse', dependencies=TRUE)" && \
    Rscript -e "install.packages('pROC', dependencies=TRUE)" && \
     Rscript -e "install.packages('Rtsne', dependencies=TRUE)"

RUN pip3 install pandas && \
    pip3 install networkx

RUN wget -qO- https://get.nextflow.io | bash && \
    mv nextflow /usr/bin/

# Gotta love docker
RUN apt-get update && apt-get install -y openssh-client