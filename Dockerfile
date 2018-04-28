FROM openjdk:8

LABEL author="kieranrcampbell"

# Install container-wide requrements gcc, pip, zlib, libssl, make, libncurses, fortran77, g++, R
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        g++ \
        gawk \
        gcc \
        gfortran \
        libboost-all-dev \
        libbz2-dev \
        libcurl4-openssl-dev \
        libdbd-mysql \
        libgsl0-dev \
        liblzma-dev \
        libmariadb-client-lgpl-dev \
        libncurses5-dev \
        libpcre3-dev \
        libreadline-dev \
        libssl-dev \
        libxml2-dev \
        make \
        python-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Cairo
RUN apt-get update && apt-get -y install libcairo2-dev

# Install X-11
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xauth \
    xorg \
    openbox


# Install pip
RUN curl -fsSL https://bootstrap.pypa.io/get-pip.py -o /opt/get-pip.py && \
    python /opt/get-pip.py && \
    rm /opt/get-pip.py


# Install R
ENV R_VERSION="R-3.5.0"
RUN curl -fsSL https://cran.r-project.org/src/base/R-3/${R_VERSION}.tar.gz -o /opt/${R_VERSION}.tar.gz && \
    tar xvzf /opt/${R_VERSION}.tar.gz -C /opt/ && \
    cd /opt/${R_VERSION};./configure;make;make install && \
    rm /opt/${R_VERSION}.tar.gz

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


# Install R Bioconductor packages
RUN echo 'source("https://bioconductor.org/biocLite.R")' > /opt/packages.r && \
    echo 'biocLite()' >> /opt/packages.r && \
    echo 'biocLite(c("SingleCellExperiment", "Rsamtools", "ShortRead", "GenomicRanges", "GenomicFeatures", "ensembldb", "scater", "biomaRt", "org.Hs.eg.db", "org.Mm.eg.db", "scran"))' >> /opt/packages.r && \
    Rscript /opt/packages.r && \
    mkdir /usr/local/lib/R/site-library

# Install some extra R packages
RUN Rscript -e "install.packages('devtools', dependencies=TRUE)" && \
    Rscript -e "devtools::install_github('jeremystan/aargh')"

# Install tensorflow for R
RUN python3 -m pip install --user virtualenv && \
    Rscript -e "install.packages('tensorflow'); tensorflow::install_tensorflow()"

# Install Rstudio server
RUN apt-get install gdebi-core && \
    wget https://download2.rstudio.org/rstudio-server-1.1.447-amd64.deb && \
    gdebi rstudio-server-1.1.447-amd64.deb && \
    rm rstudio-server-1.1.447-amd64.deb

# Install tree
RUN apt-get update && apt-get install tree


RUN curl -fsSL get.nextflow.io | bash && mv nextflow /usr/local/bin/

# Sort Rprofile crap

# ENV R_PROFILE=/etc/R

RUN echo "options(bitmapType='cairo')" > /usr/local/lib/R/etc/Rprofile.site