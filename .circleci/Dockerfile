FROM ubuntu:16.04

RUN apt-get update && \
    apt-get -y install curl

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

RUN apt-get -y install python-pip python-dev build-essential && \
    pip install --upgrade pip && \
    pip --no-cache-dir install awscli