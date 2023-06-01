# docker-retool
Dockerfile used to build retool cli

Current issues with retool 2.00.5 means that this Dockerfile is based on retool 2.00.3

build.sh is used to build image, however if you want to do this without build.sh, please specify --build-arg UID=$UID when building
