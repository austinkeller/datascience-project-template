#!/usr/bin/env sh
name={{ cookiecutter.project_slug }}
__PORT=$(docker container port $name | command grep -o ':[0-9]*')
__TOKEN_KEY=$(docker container logs $name 2>&1 | command grep -o -m1 'http://127.0.0.1:[0-9]*/?token=*[a-z0-9]*' | command grep -o -m1 'token=[a-z0-9]*')
echo "http://127.0.0.1${__PORT}/?${__TOKEN_KEY}"
