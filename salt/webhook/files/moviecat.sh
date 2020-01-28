#!/usr/bin/env bash

_DIR='/srv/moviecat'

function git_refrsesh {
    cd ${_DIR}
    sudo -u ludovic git fetch --all
    sudo -u ludovic git pull --prune
}

function reload_gunicorn {
    cd ${_DIR}
    systemctl restart gunicorn.socket
}

function rebuild_js {
    cd "${_DIR}/www"
    yarn build
}

git_refrsesh
reload_gunicorn
rebuild_js
