#!/usr/bin/env sh

set -e

name={{ cookiecutter.project_slug }}

docker kill $name
