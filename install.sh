#!/bin/bash

#*****************************************************************
#*
#* Copyright 2019 IBM Corporation
#*
#* Licensed under the Apache License, Version 2.0 (the "License");
#* you may not use this file except in compliance with the License.
#* You may obtain a copy of the License at

#* http://www.apache.org/licenses/LICENSE-2.0
#* Unless required by applicable law or agreed to in writing, software
#* distributed under the License is distributed on an "AS IS" BASIS,
#* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#* See the License for the specific language governing permissions and
#* limitations under the License.
#*
#*****************************************************************
org=$1
kubeenv=$2
arg=$org
# make sure running in build directory 
if [ $(echo $PWD | awk '{ n=split($0,d,"/"); print d[n] }') != 'build' ]; then 
    echo 'Error: $kappnav/build dir must be current dir.'
    echo ''
    arg="--?"
fi

if [ x$arg == x'--?' ] || [ x$arg == 'x' ]; then
    echo "Install kAppNav from specified dockerhub.com organization."
	echo "Will install images tagged latest."
	echo 
	echo "syntax:" 
	echo 
	echo "install.sh <docker organization> [kube env]"
	echo 
	echo "kube env is one of:  ocp, okd, minikube.  Default is okd."
	exit 1
fi

# set default kubeenv if not specified 
if [ x$kubeenv == 'x' ]; then
	kubeenv=okd
else
# validate
	if ! [ $kubeenv == 'ocp' ] && ! [ $kubeenv == 'okd' ] && ! [ $kubeenv == 'minikube' ]; then
		echo "kubeEnv $kubeenv value is not valid.  Must be ocp, okd, or minikube"
		exit 1
	fi
fi

if [ -d ../operator ]; then 

	# pluck image tag off operator image 
	tag=$(cat ../operator/kappnav.yaml | grep operator: | awk '{ split($0,p,":"); print p[3] }')

	echo Install kappnav to kubeenv $kubeenv
	kubectl create namespace kappnav 

	cat ../operator/kappnav.yaml | sed "s|kubeEnv: okd|kubeEnv: $kubeenv|" | sed "s|repository: kappnav/|repository: $org/kappnav-|" | sed "s|tag: $tag|tag: latest|" | sed "s|image: kappnav/operator:$tag|image: $org/kappnav-operator:latest|" | kubectl create -f - -n kappnav 
else
	echo Cannot install: file ../operator/kappnav.yaml not found. 
	exit 1
fi
