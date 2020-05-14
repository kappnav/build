#!/bin/bash
#*****************************************************************
#*
#* Copyright 2020 IBM Corporation
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
# does git tag on all projects with releases
tagName=$1
tagMessage=$2

# make sure running in build directory
if [ $(echo $PWD | awk '{ n=split($0,d,"/"); print d[n] }') != 'build' ]; then
  echo 'Error: $kappnav/build dir must be current dir.'
  echo
    arg="--?"
fi

# check arguments and print help message if needed
if [ x$tagName == x'--?' ] || [ x$tagName == x'-?' ] || [ x$tagName == 'x' ] || [ ${#tagMessage} == 0 ]; then
	echo Create an annotated tag in all kAppNav projects.
	echo
	echo syntax:
	echo
	echo "tag.sh <tagName> \"<tagMessage>\""
	echo
	echo "An example of the pattern to follow: ./tag.sh v0.8.0 \"Version 0.8.0\""
	exit 0
fi

# create tags and push to origin
. ./projectList.sh
for p in $ALL_PROJECTS; do
  if [ -d ../$p ]; then
    cd ../$p
    echo Tagging $p repository
    read -p "If a commit other than HEAD is needed enter it now: " commit
    git tag -a $tagName -m \"$tagMessage\" $commit
    if [ $? -eq 0 ]; then
      git push origin $tagName
    fi
  fi
done

# go back to original directory
cd ../build
