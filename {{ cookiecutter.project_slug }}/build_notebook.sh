#!/usr/bin/env sh

image={{ cookiecutter.project_slug }}

# Is ssh-agent running with a key in it?
if ! ssh-add -l; then
         eval $(ssh-agent -s)
                 ssh-add ~/.ssh/id_rsa
fi

DOCKER_BUILDKIT=1 docker build --ssh default -t $image .
