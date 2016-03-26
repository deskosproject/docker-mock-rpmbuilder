#!/bin/bash

VOLUME_FOLDER=/mock
RESULT_FOLDER=${VOLUME_FOLDER}/result
MOCK_CONFIG=epel-7-x86_64

shopt -s dotglob

if [ ! -d "${RESULT_FOLDER}" ]; then
  mkdir ${RESULT_FOLDER}
else
  rm -f ${RESULT_FOLDER}/*
fi

rpmdev-setuptree

cp -p ${VOLUME_FOLDER}/SPECS/*.spec ~/rpmbuild/SPECS/

if [ -d ${VOLUME_FOLDER}/SOURCES ] ; then
  cp -pr ${VOLUME_FOLDER}/SOURCES/* ~/rpmbuild/SOURCES/
fi

spectool -g -R ~/rpmbuild/SPECS/*.spec

SPEC=$(find ~/rpmbuild/SPECS/ -type f -name "*.spec")

/usr/bin/mock -r ${MOCK_CONFIG} --buildsrpm --spec=${SPEC} --sources=~/rpmbuild/SOURCES --no-cleanup-after

SRPM=$(find /var/lib/mock/${MOCK_CONFIG}/result -type f -name "*.src.rpm")

/usr/bin/mock -r ${MOCK_CONFIG} --rebuild ${SRPM} --no-clean

cp -p /var/lib/mock/${MOCK_CONFIG}/result/* ${RESULT_FOLDER}

