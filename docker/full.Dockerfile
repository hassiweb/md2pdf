FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -yq \
    wget unzip ghostscript perl-modules

# Install TeX Live
ENV TL_VERSION 2020
ENV TL_PATH /usr/local/texlive
ENV PATH ${TL_PATH}/bin/x86_64-linux:/bin:${PATH}
RUN cd /tmp \
 && mkdir install-tl-unx \
 && wget -qO- http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
    tar -xz -C ./install-tl-unx --strip-components=1 \
 && printf "%s\n" \
    "TEXDIR ${TL_PATH}" \
    "selected_scheme scheme-full" \
    "option_doc 0" \
    "option_src 0" \
    > ./install-tl-unx/texlive.profile \
 && ./install-tl-unx/install-tl \
    -profile ./install-tl-unx/texlive.profile \


# Install Pandoc from a deb package file (choose your suitable version from https://github.com/jgm/pandoc/releases)
ENV PANDOC_VERSION 2.9.2.1
RUN cd /tmp \
 && wget https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-amd64.deb \
 && dpkg -i pandoc-${PANDOC_VERSION}-1-amd64.deb

# Insert GitLab style math filter
COPY gitlab-math.lua /opt/lualatex/filter/gitlab-math.lua

# Clean up
RUN apt-get autoclean \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* 

WORKDIR /data
# ENTRYPOINT [ "pandoc" ]
# CMD [ "-h" ]

