FROM kalilinux/kali-rolling

LABEL org.label-schema.name='Sn1per - Kali Linux' \
    org.label-schema.description='Automated pentest framework for offensive security experts' \
    org.label-schema.usage='https://github.com/sredevopsdev/Sn1per' \
    org.label-schema.url='https://github.com/sredevopsdev/Sn1per' \
    org.label-schema.vendor='https://sredevops.dev' \
    org.label-schema.schema-version='1.0' \
    org.label-schema.docker.cmd.devel='docker run --rm -ti sredevopsdev/Sn1per'

RUN echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
        && apt-get -yqq update \
        && apt-get -yqq dist-upgrade \
        && apt-get clean
RUN apt-get install -y metasploit-framework

RUN sed -i 's/systemctl status ${PG_SERVICE}/service ${PG_SERVICE} status/g' /usr/bin/msfdb && \
    service postgresql start && \
    msfdb reinit

RUN mkdir -pv /security/Sn1per

WORKDIR /security/Sn1per

COPY . .

RUN ./install.sh \
    && sniper -u force

CMD ["bash"]
