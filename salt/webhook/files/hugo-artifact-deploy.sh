#!/usr/bin/env bash

_DIR='/srv/web/www/'
_WORKING_DIRECTORY='/tmp'

## Build direcotry if not present
mkdir -p ${_DIR}

## Deleting remaining directory, in case
rm -rf ${_WORKING_DIRECTORY}/hugo_website

## Clone the repository
cd ${_WORKING_DIRECTORY}
gh repo clone Whyrl35/hugo_website
cd ${_WORKING_DIRECTORY}/hugo_website

## Debug
gh auth login --with-token < /root/.config/gh/token
gh auth status

## Find artifacts and download it.
ID=`gh run list -L 1 -w CI |  grep -o -E "[0-9]+" | sort -n | tail -n 1`
gh run download ${ID} -n app-build

## List artifacts if downloaded
artifact="$(git log | head -n 1 | awk '{ print $2 }')"
if [ "${artifact}" != "" ]
then
	tar xvpf ${artifact}.tar.gz --strip 1 -C ${_DIR}
	## Changing the rights
	chown ludovic:www-data -R ${_DIR}
	chmod -R ug+rwX,o+rX,o-w ${_DIR}
else
	echo "No artifacts downloaded..."
fi

## Removing repository from working direcotry
rm -rf ${_WORKING_DIRECTORY}/hugo_website
