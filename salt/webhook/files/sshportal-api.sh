#!/usr/bin/env bash

systemctl restart docker-sshportal-api.service
docker system prune -f -a
