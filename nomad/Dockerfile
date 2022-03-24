# https://releases.hashicorp.com/nomad/1.2.3/nomad_1.2.3_linux_amd64.zip
FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

USER root

# RUN addgroup nomad && adduser -S -G nomad nomad

# RUN mkdir -p /nomad/data && \
#     mkdir -p /etc/nomad && \
#     chown -R nomad:nomad /nomad

EXPOSE 4646 4647 4648 4648/udp

ADD start.sh /usr/local/bin/start.sh

ENV NOMAD_VERSION 1.2.3
  
RUN apt update && apt install -y apt-utils curl gnupg2 software-properties-common

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -

RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

RUN apt-get update && apt-get install -y nomad

ENTRYPOINT ["/usr/local/bin/start.sh"]