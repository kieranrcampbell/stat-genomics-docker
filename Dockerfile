FROM rocker/rstudio:latest

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


RUN apt-get update && \
    apt-get install -y zlib1g-dev && \
    apt-get install -y pkg-config libxml2-dev && \
    apt-get install -y emacs && \
    apt-get install -y openssh-client && \
    apt-get install -y jags

# Install snakemake
RUN apt-get update && apt install -y python3-pip && \
    pip3 install snakemake

RUN pip3 install pandas && \
    pip3 install networkx

# Install nextflow
RUN wget -qO- https://get.nextflow.io | bash && \
    mv nextflow /usr/bin/


# Install miniconda to /miniconda
RUN curl -LO https://repo.anaconda.com/archive/Anaconda3-2018.12-Linux-x86_64.sh
RUN bash Anaconda3-2018.12-Linux-x86_64.sh -p /anaconda -b
RUN rm Anaconda3-2018.12-Linux-x86_64.sh
ENV PATH=/anaconda/bin:${PATH}
RUN conda update -y conda

# Create tensorflow environment?
RUN conda create -n py36 python=3.6 anaconda

# Create environment
RUN conda create -n py27 python=2.7 anaconda

# Install packages
RUN /bin/bash -c "source /anaconda/bin/activate py27" && \
    conda install -n py27 -y \
    numpy \
    pandas \
    scipy && \
    conda install -n py27 -y -c bioconda pysam

# Install samtools
RUN apt-get install -y samtools

RUN /bin/bash -c "source /anaconda/bin/activate py36"

# Install tensorflow for R

# First for root
RUN sudo apt-get install -y python-pip && \
    sudo python -m pip install virtualenv && \
    Rscript -e "install.packages('tensorflow');" && \
    Rscript -e "tensorflow::install_tensorflow(extra_packages = 'tensorflow-probability')"

# Then for rstudio
RUN usermod -aG sudo rstudio && \
    echo "rstudio ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER rstudio

RUN /bin/bash -c "source /anaconda/bin/activate py36"

RUN Rscript -e "install.packages('tensorflow'); tensorflow::install_tensorflow(extra_packages = 'tensorflow-probability')"

RUN sudo chown -R "rstudio" /home/rstudio/


USER root


# Install CRAN packages
ADD install_cran.R /tmp/
RUN Rscript /tmp/install_cran.R

# Install bioc packages
ADD install_bioc.R /tmp/
RUN Rscript /tmp/install_bioc.R

# Install github packages
ADD install_github.R /tmp/
RUN Rscript /tmp/install_github.R

# Install packages
RUN /bin/bash -c "source /anaconda/bin/activate py36" && \
    conda install -n py36 -y \
    numpy \
    pandas \
    scipy && \
    conda install -n py36 -y -c bioconda pysam && \
    conda install -c conda-forge jupyterlab

USER rstudio

ENV PATH $PATH:/anaconda/bin/

USER root

EXPOSE 8888

# Install Tensorflow again

USER rstudio

RUN /bin/bash -c "source /anaconda/bin/activate py36"

RUN Rscript -e "install.packages('tensorflow'); tensorflow::install_tensorflow(extra_packages = 'tensorflow-probability', version = '1.12.0')"

RUN sudo chown -R "rstudio" /home/rstudio/


USER root

RUN sudo apt-get install -y python-pip && \
    sudo python -m pip install virtualenv && \
    Rscript -e "install.packages('tensorflow');" && \
    Rscript -e "tensorflow::install_tensorflow(extra_packages = 'tensorflow-probability', version='1.12.0')"
