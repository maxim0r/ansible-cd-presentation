SHELL := /bin/bash

VERSION = 0.0.1
REGISTRY = registry.example.com:5000
HOST ?= all

build:
		go build -ldflags "-X main.Version=${VERSION}" -o webapp

build_image:
		docker build --no-cache -t webapp:${VERSION} .

run:
		docker run -d -p 8000:8000 webapp:${VERSION}

env:
		mkdir -p infrastructure/roles/custom
		mkdir -p infrastructure/roles/public
		mkdir -p infrastructure/group_vars
		mkdir -p infrastructure/host_vars
		mkdir -p infrastructure/vars
		mkdir -p infrastructure/files
		touch infrastructure/vars/credentials.yml
		touch infrastructure/inventory
		touch infrastructure/group_vars/all
		cp tpl/ansible/ansible.cfg infrastructure/
		cp -r tpl/.ssh infrastructure/

fact:
		cd ./infrastructure && ansible $(HOST) -m setup

site:
		cd ./infrastructure && ansible-playbook --limit $(HOST) site.yml

roles:
		cd ./infrastructure && ansible-galaxy install angstwad.docker_ubuntu
		cd ./infrastructure && ansible-galaxy install git+https://github.com/maxim0r/docker-registry

registry:
		cd ./infrastructure && ansible-playbook registry.yml

local:
		cd ./infrastructure && ansible-playbook -i "localhost," -c local common.yml 

list:
		docker-ls repositories --registry https://${REGISTRY} --allow-insecure --basic-auth --user admin --password qwerty123 --level 1

docker_push:
		docker login ${REGISTRY}
		docker tag webapp:${VERSION} ${REGISTRY}/webapp:${VERSION}
		docker push ${REGISTRY}/webapp:${VERSION}
