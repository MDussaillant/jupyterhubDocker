FROM jupyterhub/jupyterhub:0.9

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

RUN mkdir -p /home/$JH_ADMIN/.jupyter

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
    jupyter_contrib_nbextensions \
	jupyterhub-ldapauthenticator==1.3.0

RUN jupyter contrib nbextension install --sys-prefix

# Install miniconda
#ENV CONDA_DIR /opt/conda
#RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_4.9.2-Linux-x86_64.sh -O ~/miniconda.sh && \
 #    /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
#ENV PATH=$CONDA_DIR/bin:$PATH

#RUN sed -i 's/PATH="/PATH="\/opt\/conda\/bin:/g' /etc/environment



# Dossier feedback
RUN mkdir /srv/feedback && \
    chmod 4777 /srv/feedback




EXPOSE 8000
