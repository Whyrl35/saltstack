#!/usr/bin/env bash

systemctl restart docker-sshportal-ui.service
docker system prune -f -a
