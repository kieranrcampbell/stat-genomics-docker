# stat-genomics-docker
Docker file for statistical genomics (single-cell focus)


# Workflow

## Building Docker image

To build the image, navigate to the directory with the `Dockerfile` and run

```
docker build -t statgen .
```

## Running Docker image

To jump into an SSH session call

```
docker run --rm -v /krcdata:/krcdata -it -e "TERM=xterm-256color" cellassign1 bash -l
```

where `krcdata` is a disk mounted that you wish shared with the docker container.

## Running RStudio server in the Docker image

Call

```
docker run -v /krcdata:/krcdata -d -p 8787:8787 rocker/tidyverse
```

