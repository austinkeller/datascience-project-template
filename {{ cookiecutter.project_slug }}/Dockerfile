# syntax=docker/dockerfile:1.0.0-experimental
{% if cookiecutter.platform_slug == 'jupyter' %}
FROM jupyter/datascience-notebook:3b1f4f5e6cc1
{% elif cookiecutter.platform_slug == 'rstudio' %}
FROM rocker/rstudio
{% elif cookiecutter.platform_slug == 'shiny' %}
FROM rocker/shiny
{% elif cookiecutter.platform_slug == 'bioconductor' %}
FROM bioconductor/release_core2
{% endif %}

MAINTAINER {{ cookiecutter.full_name}} <{{ cookiecutter.email }}>

{% if cookiecutter.platform_slug == 'jupyter' %}
USER root
{% endif %}

# Install additional system packages here, if necessary
RUN apt-get update \
      && apt-get install -y \
      ssh \
      curl \
      build-essential \
      swig \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

# If packages need to be installed via ssh, add them here
# Note: This bypasses host key checking. The fingerprint should be copied into
#   the known_hosts file in this repo if going over external network to mitigiate MITM
#RUN --mount=type=ssh ssh -o "StrictHostKeyChecking=no" -T git@github.com

{% if cookiecutter.platform_slug == 'jupyter' %}
# create and change working directory
WORKDIR /home/jovyan

# Custom python packages from git repositories using git+ format, for example:
#  -e git+https://github.com/your_username/your_package@your_tag#egg=your_package
#  -e git+https://bitbucket.org/atkeller/proteomics_tools/get/v0.2.1.tar.gz#egg=proteomics-tools
#  or for a local repository (for testing)
#  -e git+file://./src/your_package#egg=your_package
#  see https://pip.readthedocs.io/en/1.1/requirements.html#requirements-file-format
ADD requirements.txt /src/
RUN --mount=type=ssh \
      pip install -r /src/requirements.txt

RUN fix-permissions $CONDA_DIR && \
          fix-permissions /home/$NB_USER

USER $NB_USER
{% endif %}

# Custom R packages
ADD install_packages.r /src/
RUN Rscript /src/install_packages.r
