# Utiliser rocker/tidyverse comme image de base
FROM rocker/tidyverse

# Mettre à jour les packages du système
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libudunits2-dev \
  libgdal-dev \
  libgeos-dev \
  libproj-dev

# Installer quarto-cli
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.554/quarto-1.4.554-linux-amd64.deb && \
    dpkg -i quarto-1.4.554-linux-amd64.deb && \
    rm quarto-1.4.554-linux-amd64.deb

# Installer le package rmarkdown
RUN install2.r --error \
  --deps TRUE \
  rmarkdown

# Installer les packages R
RUN install2.r --error \
  --deps TRUE \
  quarto \
  sf \
  hubeau \
  leaflet \
  htmltools \
  DT
