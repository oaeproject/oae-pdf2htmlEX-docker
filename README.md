# oae-pdf2htmlEX-docker

Container image based on alpine linux for Hilary to run on with all system dependencies. Makes the [previous deps image](https://github.com/oaeproject/oae-hilary-deps-docker) obsolete.

## Usage

This is most useful when used with docker-compose. Check the `docker-compose.yml` file on [Hilary](https://github.com/oaeproject/Hilary).

If you still want to be able to run this in standlone mode, then follow these steps:

### Run from dockerhub

```console
docker run -it --name=hilary --net=host oaeproject/oae-pdf2htmlex-docker
```

### Build the image locally

```console
# Step 1: Build the image
docker build -f Dockerfile -t hilary:latest .
# Step 2: Run image
docker run -it --name=hilary --net=host oae-pdf2htmlex-docker:latest
```
