#!/bin/bash

start-local-apiserver () {
cd /Users/d060239/Development/vagrant/archlinux
vagrant up
vagrant ssh -c "cd /Users/d060239/go/src/github.com/gardener/gardener; sudo su;  make local-garden-up; make dev-setup; make start-apiserver"
}