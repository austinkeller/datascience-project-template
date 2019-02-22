{% if cookiecutter.platform_slug == 'jupyter' %}
jupyter/datascience-notebook:83ed2c63671f
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

# Install system packages here, if necessary
# RUN apt-get update -y && apt-get install -y your-desired-packages

{% if cookiecutter.platform_slug == 'jupyter' %}
USER $NB_USER

# create and change working directory
WORKDIR /home/jovyan

# Custom python packages from git repositories using git+ format, for example:
#  -e git+https://github.com/your_username/your_package@your_tag#egg=your_package
#  -e git+https://bitbucket.org/atkeller/proteomics_tools/get/v0.2.1.tar.gz#egg=proteomics-tools
#  or for a local repository (for testing)
#  -e git+file://./src/your_package#egg=your_package
#  see https://pip.readthedocs.io/en/1.1/requirements.html#requirements-file-format
ADD requirements.txt /src/
RUN pip install -r /src/requirements.txt
{% endif %}

# Custom R packages
ADD install_packages.r /src/
RUN Rscript /src/install_packages.r
