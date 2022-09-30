#!/bin/sh

set -e

DOCKER_COMPOSE_PATH=/usr/local/invoicer/docker-compose.yml
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID:-637752312216}"
AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-eu-central-1}"

aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
docker-compose -f $DOCKER_COMPOSE_PATH pull
docker-compose -f $DOCKER_COMPOSE_PATH up -d

