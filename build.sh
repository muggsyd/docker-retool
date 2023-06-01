#!/bin/bash
docker build . -t retool:latest --build-arg UID=1000  #--no-cache
