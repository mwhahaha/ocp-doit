#!/bin/bash

set -x

sudo docker ps -aq | xargs sudo docker stop
sudo docker ps -aq | xargs sudo docker rm -f

sudo docker volume ls -q | xargs sudo docker volume rm
sudo rm -Rf /var/lib/mysql
sudo rm -Rf /var/lib/rabbitmq
sudo rm -Rf /var/lib/heat-config/*
