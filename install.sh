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
reposArg=$3
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
	echo
	echo "   optional: <repo1,repo2,repo3>  list of local repos to use separated by comma."
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

	if [[ x$reposArg == 'x' || x$reposArg == "" ]]; then
		cat ../operator/kappnav.yaml | sed "s|kubeEnv: okd|kubeEnv: $kubeenv|" | sed "s|repository: kappnav/|repository: $org/kappnav-|" | sed "s|tag: $tag|tag: latest|" | sed "s|image: kappnav/operator:$tag|image: $org/kappnav-operator:latest|" | kubectl create -f - -n kappnav 
	else
		# parse the arguments using "," deliminiter
		IFS=',' read -r -a repos <<< "$reposArg"

		org=$DOCKER_USER
		echo $DOCKER_PWD | docker login docker.io -u $DOCKER_USER --password-stdin
		. ./projectList.sh
		projs=$IMAGES
		
		cat ../operator/kappnav.yaml | \
    		sed "s|kubeEnv: okd|kubeEnv: $kubeenv|" | \
    		sed "s|tag: $tag|tag: dev|" | \
    		sed "s|image: kappnav/operator:$tag|image: kappnav/operator:dev|" \
    		> temp-kappnav.yaml
		for p in $projs; do
    		for repo in "${repos[@]}"; do
        		if [ x$repo == x$p ]; then
					if [ x$repo == x"operator" ]; then
						sed "s|image: kappnav/operator:dev|image: $DOCKER_USER/kappnav-operator:latest|" temp-kappnav.yaml > temp-kappnav-new.yaml
					else
            			r="repository: kappnav/"$repo
						# get the line number of the repo that the tag need to be updated
						ln=`grep -n "$r" ../operator/kappnav.yaml | awk -F: '{print $1}'`
						newln=$(($ln+1))
						cat temp-kappnav.yaml | \
						sed "$ln s|repository: kappnav/|repository: $DOCKER_USER/kappnav-|" | \
    					sed "$newln s|tag: dev|tag: latest|" > temp-kappnav-new.yaml
					fi
					cat temp-kappnav-new.yaml > temp-kappnav.yaml
        		fi
    		done
		done
		kubectl create -f temp-kappnav.yaml -n kappnav
	fi
else
	echo Cannot install: file ../operator/kappnav.yaml not found. 
	exit 1
fi
