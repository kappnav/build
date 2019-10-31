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
# this script uninstalls kAppNav from kubernetes cluster 
# corresponding to currently active kube config 
#
# Issue 'kubectl config current-context' if you are uncertain.
arg=$1
if [ $(echo $PWD | awk '{ n=split($0,d,"/"); print d[n] }') != 'build' ]; then 
    echo 'Error: $kappnav/build dir must be current dir.'
    echo ''
    arg="--?"
fi

if [ x$arg == x'--?' ]; then
    echo "This script uninstalls kAppNav from current kubernetes cluster." 
    echo ""
    echo "Issue 'kubectl config current-context' to confirm current cluster."
    echo ""
	echo "syntax:"
	echo ""
	echo "uninstall.sh"
    exit 1
fi

kubectl delete -f ../operator/kappnav-delete-CR.yaml -n kappnav --now
kubectl delete -f ../operator/kappnav-delete.yaml -n kappnav
kubectl delete namespace kappnav