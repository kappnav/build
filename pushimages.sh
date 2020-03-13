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
# push all images or specified image to docker hub
org=$1
image=$2

arg=$org
# make sure running in build directory
if [ $(echo $PWD | awk '{ n=split($0,d,"/"); print d[n] }') != 'build' ]; then
    echo 'Error: $kappnav/build dir must be current dir.'
    echo ''
    arg="--?"
fi

if [ x$arg == x'--?' ] || [ x$arg == 'x' ]; then
	echo Push local kAppNav images to specified dockerhub.com organization.
	echo
	echo Notes:
	echo "1. this script will attempt 'docker login'"
	echo "2. images will be tagged latest"
	echo
	echo syntax:
	echo
	echo "pushimages.sh <docker organization> [<image>]"
	echo
	echo "Where image is one of: inv, ui, apis, controller, operator"
	exit 1
fi

docker login

if [ x$image == x ]; then
	. ./projectList.sh
	imagelist=$IMAGES
else
	imagelist=$image
fi
tag=latest
for image in $imagelist; do
   echo docker tag kappnav-$image:$tag $org/kappnav-$image:$tag
   docker tag kappnav-$image:$tag $org/kappnav-$image:$tag
   echo docker push $org/kappnav-$image:$tag
   docker push $org/kappnav-$image:$tag
done
