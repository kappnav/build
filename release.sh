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
# Create a new release of kAppNav

# make sure we're running in the build directory
if [ $(echo $PWD | awk '{ n=split($0,d,"/"); print d[n] }') != 'build' ]; then
  echo 'Error: $kappnav/build dir must be current dir.'
  echo ''
  arg="--?"
fi

# make sure prereqs are satisfied
. ./version.sh
echo "Before running this command you must have done the following."
echo "   1) Checkout the branch on which to create the release for each repository,"
echo "      or the commit if not HEAD"
echo "   2) Build and test with setupKAppNavTestEnv.sh"
echo "   3) Ensure version.sh contains the correct version number"
echo "   4) If any repository is at a commit other than HEAD you must create"
echo "      the release tag.  For example:"
echo "          git tag -a v0.8.0 \"Version 0.8.0\" 7ee0895"
echo
echo "Are you ready to create kAppNav version $VERSION?"
select response in "Yes" "No"; do
  case $response in
    Yes ) break;;
    No ) exit 1;;
  esac
done

# because we use version numbers as image tags the operator project needs to be
# updated for each release
./updateOperatorForNewRelease.sh

# create the release tag in each repository
TAG=$VERSION
TAG_MSG="Version "$VERSION
./tag.sh $TAG \"$TAG_MSG\"

# publish kAppNav images to Docker Hub
./pushKAppNavToDockerHub.sh --noprompt
