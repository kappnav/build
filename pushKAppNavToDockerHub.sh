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
# push all images or specified image to Docker Hub
image=$1

if [ x$1 == x'--?' ] || [ x$1 == x'-?' ]; then
	echo Push local Kubernetes Application Navigator images to Docker Hub
  echo
	echo Notes:
	echo "1. This script will attempt 'docker login docker.io'"
	echo "2. Images will be tagged with the current version number from ./version.sh"
	echo
	echo syntax:
	echo
	echo "./pushToKAppNavStaging.sh [<image>]"
	echo
  echo "By default all images are pushed.  A single image can be pushed by providing the optional"
  echo "image parameter, where image is one of: apis, controller, init, operator, ui"
	exit 1
fi

if [ x$image == x ]; then
	imagelist="apis controller init operator ui"
else
	imagelist=$image
fi

echo Logging into Docker Hub
docker login docker.io

. ./version.sh
tag=$VERSION

echo Proceed with tagging kappnav images as $tag and pushing to docker.io/kappnav?
select response in "Yes" "No"; do
    case $response in
        Yes ) break;;
        No ) exit 1;;
    esac
done

for image in $imagelist; do
   echo docker tag kappnav-$image docker.io/kappnav/$image:$tag
   docker tag kappnav-$image docker.io/kappnav/$image:$tag
   echo docker push docker.io/kappnav/$image:$tag
   docker push docker.io/kappnav/$image:$tag
done
