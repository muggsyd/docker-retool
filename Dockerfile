FROM python:3.10-slim  AS compile-image
MAINTAINER Arran Davis <arran.davis@gmail.com>

RUN apt-get update && apt-get install git -y \
  curl \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Configure Poetry
ENV POETRY_VERSION=1.4.0
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv
ENV POETRY_CACHE_DIR=/opt/.cache

# Install poetry separated from system interpreter
RUN python3 -m venv $POETRY_VENV \
    && $POETRY_VENV/bin/pip install -U pip setuptools \
    && $POETRY_VENV/bin/pip install lxml strictyaml alive-progress psutil bs4 pysimpleguiqt \
    && $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

# Add `poetry` to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"

RUN git clone https://github.com/unexpectedpanda/retool.git /usr/src/app/
RUN git checkout 96be958
RUN mv readme.md README.md
RUN poetry install --only main

FROM python:3.10-slim AS build-image
ARG UID
RUN adduser -D -u $UID -G users -s /bin/sh -h /retool retool
COPY --from=compile-image /opt/poetry-venv /opt/poetry-venv
COPY --from=compile-image --chown=retool:users /usr/src/app /retool

# Make sure we use the virtualenv:
ENV PATH="/opt/poetry-venv/bin/:$PATH"
RUN apt-get update && apt-get install xmlstarlet -y
WORKDIR /retool
CMD [ "python3","/retool/retool.py","--help" ]
