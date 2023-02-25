FROM kalilinux/kali-rolling AS builder

LABEL org.label-schema.name='Sn1per - Kali Linux SREDevOps.dev mod' \
      org.label-schema.description='Automated pentest framework for offensive security experts' \
      org.label-schema.usage='https://github.com/sredevopsdev/sn1per' \
      org.label-schema.url='https://github.com/sredevopsdev/sn1per' \
      org.label-schema.vendor='https://sredevops.dev' \
      org.label-schema.schema-version='1.0' \
      org.label-schema.docker.cmd.devel='docker run --rm -ti ghcr.io/sredevopsdev/sn1per:latest'

RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
        && apt -y update && apt install -y metasploit-framework

RUN sed -i 's/systemctl status ${PG_SERVICE}/service ${PG_SERVICE} status/g' /usr/bin/msfdb && \
    service postgresql start && \
    msfdb reinit

RUN mkdir -pv /security/sn1per 

WORKDIR /security/sn1per

COPY . .

RUN ./install.sh \
    && sniper -u force

FROM builder AS base

#WORKDIR /security/sn1per

CMD ["bash"]
