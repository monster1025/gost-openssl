#FROM ubuntu:latest

#RUN apt-get update && apt-get install -y git unzip sudo wget build-essential pkg-config python3 python3-pip
#RUN git clone https://github.com/kov-serg/get-cpcert.git && cd get-cpcert && chmod +x *.sh
#RUN cd /get-cpcert/ && ./prepare.sh

FROM debian
RUN apt-get update && apt-get install -y libengine-gost-openssl openssl nano mc git unzip sudo wget build-essential pkg-config python3 python3-pip

ARG PREFIX="/etc/ssl"
ARG ENGINES=/usr/lib/x86_64-linux-gnu/engines-3

# Enable engine
RUN sed -i '6i openssl_conf=openssl_def' ${PREFIX}/openssl.cnf \
  && echo "" >>${PREFIX}/openssl.cnf \
  && echo "# OpenSSL default section" >>${PREFIX}/openssl.cnf \
  && echo "[openssl_def]" >>${PREFIX}/openssl.cnf \
  && echo "engines = engine_section" >>${PREFIX}/openssl.cnf \
  && echo "" >>${PREFIX}/openssl.cnf \
  && echo "# Engine scetion" >>${PREFIX}/openssl.cnf \
  && echo "[engine_section]" >>${PREFIX}/openssl.cnf \
  && echo "gost = gost_section" >>${PREFIX}/openssl.cnf \
  && echo "" >> ${PREFIX}/openssl.cnf \
  && echo "# Engine gost section" >>${PREFIX}/openssl.cnf \
  && echo "[gost_section]" >>${PREFIX}/openssl.cnf \
  && echo "engine_id = gost" >>${PREFIX}/openssl.cnf \
  && echo "dynamic_path = ${ENGINES}/gost.so" >>${PREFIX}/openssl.cnf \
  && echo "default_algorithms = ALL" >>${PREFIX}/openssl.cnf \
  && echo "CRYPT_PARAMS = id-Gost28147-89-CryptoPro-A-ParamSet" >>${PREFIX}/openssl.cnf


ADD ./src /src
RUN pip install -r /src/requirements.txt --break-system-packages

ENTRYPOINT ["bash"]
