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


## Getting Jupyer to run remotely

1. Open a new port on the VM (8080)

2. On the vm run `jupyter notebook --no-browser --port=8080`

3. On the local machine open a tunnel: `ssh -N -L 8888:localhost:8080 kieran@azure_cellassign`

4. Navigate to `http://localhost:8888/`

## Getting Vscode to edit remotely

Blog post [here](https://medium.com/@prtdomingo/editing-files-in-your-linux-virtual-machine-made-a-lot-easier-with-remote-vscode-6bb98d0639a4).

1. Connect to VM: `ssh -R 52698:localhost:52698 azure_cellassign`

2. Navigate to file and execute `rmate <filename>`