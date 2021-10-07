#!/usr/bin/env bash

_DIR='/srv/web/www/'
_WORKING_DIRECTORY='/tmp'
_DEBUG=true

## Build direcotry if not present
mkdir -p ${_DIR}

## Deleting remaining directory, in case
${_DEBUG} && echo "... Deleting old repository"
rm -rf ${_WORKING_DIRECTORY}/hugo_website

## Clone the repository
${_DEBUG} && echo "... Clone new repository"
cd ${_WORKING_DIRECTORY}
gh repo clone Whyrl35/hugo_website
${_DEBUG} && echo "... Enter new repository"
cd ${_WORKING_DIRECTORY}/hugo_website

${_DEBUG} && echo "... Login to github"
gh auth login --with-token < /root/.config/gh/token
gh auth status

## Find artifacts and download it.
${_DEBUG} && echo "... Find last run ID"
ID=`gh run list -L 1 -w CI |  grep -o -E "[0-9]+" | sort -n | tail -n 1`
${_DEBUG} && echo "... Download artifact for run ID: ${ID}"
gh run download ${ID} -n app-build

## List artifacts if downloaded
${_DEBUG} && echo "... Compute artifact name"
artifact="$(git log | head -n 1 | awk '{ print $2 }')"
if [ "${artifact}" != "" ]
then
	${_DEBUG} && echo "... Uncompress artifact ${artifact}.tar.gz"
	tar xvpf ${artifact}.tar.gz --strip 1 -C ${_DIR}
	## Changing the rights
	${_DEBUG} && echo "... Change rights on dest folder ${_DIR}"
	chown ludovic:www-data -R ${_DIR}
	chmod -R ug+rwX,o+rX,o-w ${_DIR}
else
	echo "No artifacts downloaded..."
fi

## Removing repository from working direcotry
${_DEBUG} && echo "... Remove old repository"
rm -rf ${_WORKING_DIRECTORY}/hugo_website
