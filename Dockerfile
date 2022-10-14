FROM ubuntu:latest

RUN apt-get update && apt-get install -y git unzip sudo wget build-essential pkg-config
RUN git clone https://github.com/kov-serg/get-cpcert.git && cd get-cpcert && chmod +x *.sh
RUN cd /get-cpcert/ && ./prepare.sh

ENTRYPOINT ["bash"]