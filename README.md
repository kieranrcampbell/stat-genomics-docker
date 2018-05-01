# stat-genomics-docker
Docker file for statistical genomics (single-cell focus). This contains:

* R version 3.5
* Rstudio server
* Useful bioconductor packages for single-cell analysis
* Tensorflow for R
* Snakemake


# Workflow

## Building Docker image

To build the image, navigate to the directory with the `Dockerfile` and run

```
docker build -t statgen .
```

## Running Docker image

To jump into an SSH session call

```
docker run --rm -v /krcdata:/krcdata -it -e "TERM=xterm-256color" statgen bash -l
```

where `krcdata` is a disk mounted that you wish shared with the docker container.

## Running RStudio server in the Docker image

Call

```
docker run -v /krcdata:/krcdata -d -p 8787:8787 statgen
```

If running on azure this needs 8787 created as an open outbound port.

## Permanently mounting data disk 

```
sudo mount /dev/sdc1 /krcdata
```

## Run Snakemake inside the container

Slightly convoluted - 

```
docker run -t -v /krcdata/:/krcdata/ statgen snakemake -j 40 -s $(pwd)/Snakefile --directory $(pwd)
```