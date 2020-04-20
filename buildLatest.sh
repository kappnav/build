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
# Perform a build, install, and test of the latest commit in each repository

# function for converting repo name to image name
getImageName() {
  dirName=$1
  if [ $dirName == 'inventory' ]; then
    imageName=kappnav-inv
  else
    imageName=kappnav-$dirName
  fi
}

arg=$1

# make sure we're running in the build directory
if [ $(echo $PWD | awk '{ n=split($0,d,"/"); print d[n] }') != 'build' ]; then
  echo 'Error: $kappnav/build dir must be current dir.'
  echo ''
  arg="--?"
fi

# print help if we need to
if [ x$arg == x'--?' ] || [  x$arg == x'-?' ]; then
  echo ""
  echo "Build the latest kAppNav, install it and run the tests.  Note that the"
  echo "repositories will be left in the master branch."
  echo ""
  echo ""
  echo "syntax:"
  echo ""
  echo "buildLatest.sh"
  echo ""
  echo "This script uses the following environment variables."
  echo "   \$CLUSTER_URL       - the URL to your OpenShift cluster"
  echo "   \$CLUSTER_USER      - the user name for logging into your cluster; default is"
  echo "                        is kubeadmin"
  echo "   \$CLUSTER_PWD       - the password for logging into your cluster"
  echo "   \$CLUSTER_PLATFORM  - the platform type of your cluster; default is ocp"
  echo "   \$DOCKER_ORG        - the Docker org to publish to and pull from"
  echo ""
  echo "   The script will prompt for values for any missing environments variables"
  echo "   that don't have a default"
  exit 1
fi

# clean up our docker registry so we have enough space
# automatically answer 'y' to the prune prompt
echo "pruning Docker registry of dangling images"
echo "y\n" | docker image prune

# make sure all of the repositories are up to date
# then rebuild any images that are out of date
builtSomething="false"
. ./projectList.sh
for p in $BUILD_PROJECTS; do
  echo ""
  echo "***** build $p"
  cd ../$p ; git checkout master; git pull
  commit=$(git rev-parse HEAD)
  getImageName $p
  docker image inspect $imageName | grep $commit
  if [ $? -eq 0 ]; then
    echo "$imageName is already current."
  else
    echo "building $imageName"
    ./build.sh
    builtSomething="true"
  fi
  cd -
done

# if nothing was built then there's nothing else to do
if [ $builtSomething == "false" ]; then
  echo "All repositories are up to date.  No need to install and test."
  exit
fi

# publish images, install, and test
if [ x$CLUSTER_URL != x ]; then
  url=$CLUSTER_URL
else
  read -p "Enter your cluster url: " url
fi
if [ x$CLUSTER_USER != x ]; then
  user=$CLUSTER_USER
else
  user=kubeadmin
fi
if [ x$CLUSTER_PWD != x ]; then
  pwd=$CLUSTER_PWD
else
  read -p "Enter your cluster password: " url
fi
if [ x$CLUSTER_PLATFORM != x ]; then
  platform=$CLUSTER_PLATFORM
else
  platform=ocp
fi
if [ x$DOCKER_ORG != x ]; then
  org=$DOCKER_ORG
else
  read -p "Enter the Docker org to use: " org
fi

./setupKAppNavTestEnv.sh $url $user $pwd $platform $org -p
