FROM kalilinux/kali-rolling

LABEL org.label-schema.name='Sn1per - Kali Linux | SREDevOps.dev mod' \
    org.label-schema.description='Automated pentest framework for offensive security experts' \
    org.label-schema.usage='https://github.com/sredevopsdev/sn1per' \
    org.label-schema.url='https://github.com/sredevopsdev/sn1per' \
    MAINTAINER="@xer0dayz" \
    org.label-schema.vendor='https://sn1persecurity.com' \
    org.label-schema.schema-version='1.0' \
    org.label-schema.docker.cmd.devel='docker run --rm -it ghcr.io/sredevopsdev/sn1per:latest'

LABEL org.opencontainers.image.source="https://github.com/sredevopsdev/sn1per"
LABEL org.opencontainers.image.description="Automated pentest framework for offensive security experts"
LABEL org.opencontainers.image.licenses="EULA"

RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
        && apt -y update && apt -y upgrade

RUN apt install -y metasploit-framework git

RUN sed -i 's/systemctl status ${PG_SERVICE}/service ${PG_SERVICE} status/g' /usr/bin/msfdb && \
    service postgresql start && \
    msfdb reinit

RUN mkdir -pv security && cd security && git clone  https://github.com/sredevopsdev/sn1per.git && \
    cd sn1per && chmod +x install.sh && ./install.sh --force

RUN sniper -u force

CMD ["bash"]
