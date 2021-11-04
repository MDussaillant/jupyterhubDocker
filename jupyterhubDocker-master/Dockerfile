FROM jupyterhub/jupyterhub

LABEL maintainer="Olivier Lecluse <olivier.lecluse@free.fr>"

USER root

ARG JH_ADMIN=adminjh
ARG JH_PWD=wawa

RUN apt-get update && apt-get install -yq --no-install-recommends \
        python3-pip \
        git \
        g++ \
        gcc \
        libc6-dev \
        libffi-dev \
        libgmp-dev \
        make \
        xz-utils \
        zlib1g-dev \
        gnupg \
        vim \
        texlive-xetex \
        texlive-fonts-recommended \
        texlive-plain-generic \
        pandoc \
        sudo \
        netbase \
        locales \
		wget \
		iputils-ping \
 && rm -rf /var/lib/apt/lists/*

RUN echo "fr_FR.UTF-8 UTF-8" > /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=fr_FR.UTF-8 \
    && update-locale LC_ALL=fr_FR.UTF-8

ENV LC_ALL fr_FR.UTF-8
ENV LANG fr_FR.UTF-8

RUN pip install --upgrade pip
RUN pip install jupyter

RUN useradd $JH_ADMIN --create-home --shell /bin/bash


COPY jupyterhub_config.py /srv/jupyterhub/

RUN mkdir -p /home/$JH_ADMIN/.jupyter && \
    mkdir /home/$JH_ADMIN/source
COPY header.ipynb /home/$JH_ADMIN/source
RUN chown -R $JH_ADMIN /home/$JH_ADMIN && \
    chmod 700 /home/$JH_ADMIN



RUN echo "$JH_ADMIN:$JH_PWD" | chpasswd

# droits sudo root pour JH_ADMIN !!
RUN groupadd admin && \
    usermod -a -G admin $JH_ADMIN

# Paquets pip

RUN pip install mobilechelonian \
    nbconvert \
    pandas \
    matplotlib  \
    folium  \
    geopy \
    ipython-sql \
    metakernel \
    pillow \
    nbautoeval \
	jupyterlab \
    jupyterlab-server \
    jupyter_contrib_nbextensions

RUN jupyter contrib nbextension install --sys-prefix

RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda.sh && \
	bash /opt/miniconda.sh -b -p && \
	chmod 777 /root/

# Creation des exemples

COPY --chown=1000 exemples /home/$JH_ADMIN/exemples

# Dossier feedback
RUN mkdir /srv/feedback && \
    chmod 4777 /srv/feedback

# Creation des comptes
COPY comptes.csv /root
COPY import_comptes.sh /usr/bin
COPY killJup.sh /usr/bin
COPY checkmem.sh /usr/bin
COPY home /home/
RUN chmod 755 /usr/bin/*.sh
RUN /usr/bin/import_comptes.sh /root/comptes.csv


EXPOSE 8000