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

image=$2

if [ x$org == x ]; then
	echo Push local kAppNav images to specified dockerhub.com organization.
	echo 
	echo Note: this script will attempt 'docker login'
	echo 
	echo syntax:
	echo
	echo "pushimages.sh <docker organization> [<image>]"
	echo
	echo "Where image is one of: init, ui, apis, controller, operator"
	exit 1
fi

docker login 

if [ x$image == x ]; then 
	imagelist="kappnav-init kappnav-ui kappnav-apis kappnav-controller kappnav-operator" 
else 
	imagelist="kappnav-"$image
fi
tag=latest
for image in $imagelist; do
   echo docker tag $image:$tag $org/$image:$tag
   docker tag $image:$tag $org/$image:$tag
   echo docker push $org/$image:$tag
   docker push $org/$image:$tag
done