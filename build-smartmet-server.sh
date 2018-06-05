#!/bin/sh

REPOSITORIES="smartmet-library-newbase \
              smartmet-library-macgyver \
              smartmet-library-gis \
              smartmet-library-giza \
              smartmet-library-spine \
              smartmet-library-locus \
              smartmet-library-tron \
              smartmet-server \
              smartmet-engine-sputnik \
              smartmet-engine-querydata \
              smartmet-engine-geonames \
              smartmet-engine-observation \
              smartmet-engine-gis \
              smartmet-engine-contour \
              smartmet-plugin-autocomplete \
              smartmet-plugin-timeseries \
              smartmet-plugin-download \
              smartmet-plugin-admin \
              smartmet-plugin-backend \
              smartmet-plugin-meta \
              smartmet-plugin-wfs \
              smartmet-plugin-frontend \
              smartmet-plugin-wms \
             "

mkdir -p $HOME/rpmbuild/RPMS/7

for REPOSITORY in ${REPOSITORIES}
do
    docker run -h rpmbuild-el7.fmi.fi -v $HOME/rpmbuild/RPMS/7:/home/rpmbuild/rpmbuild/RPMS --rm fmidev/rpmbuild:el7 https://github.com/fmidev/$REPOSITORY.git
done
