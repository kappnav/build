#!/bin/bash

. ./setupKAppNavLib.sh   # defines the functions used below

handleParams $@

# build and push are optional and only done by request
if [ $doBuild = true ]; then
    build
fi
if [ $doPush = true ]; then
    push
fi

# login to the target cluster
login

# uninstall - try both kappnav and given namespace
oldNamespace="kappnav"
uninstall
oldNamespace=$dockerID
uninstall

# install App Nav on the target cluster
install

# install verification test
ivt

# install samples
addSamples

