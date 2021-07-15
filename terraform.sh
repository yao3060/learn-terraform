#!/bin/bash

if [ ! -f .env ]; then
  echo -e '\033[0;31m'
  echo ".env file is not exist."
  echo "Please do 'cp .env.default .env'"
  echo "Then fill the variables."
  exit 1
fi

docker run --rm -ti \
  -e "TF_ROOT=/project" \
  --env-file .env \
  -w /project \
  -v "$PWD":"/project" \
  hashicorp/terraform:latest $*
