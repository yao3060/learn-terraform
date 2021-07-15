#!/bin/bash

docker run --rm -ti \
  -e "TF_ROOT=/project" \
  --env-file .env \
  -w /project \
  -v "$PWD":"/project" \
  hashicorp/terraform:latest $*
