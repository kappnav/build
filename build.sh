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
# build all projects or specified project
proj=$1
arg=$proj

# make sure running in build directory
if [ $(echo $PWD | awk '{ n=split($0,d,"/"); print d[n] }') != 'build' ]; then
    echo 'Error: $kappnav/build dir must be current dir.'
    echo ''
    arg="--?"
fi

if [ x$arg == x'--?' ]; then
    echo "Builds all or specified kAppNav project by cloning and building all code repos:"
	echo ""
	echo "syntax:"
	echo ""
	echo "build.sh [project]"
	exit 1
fi

# determine if building all projects or just one
if [ x$proj == x ]; then
    . ./projectList.sh
    projs=$BUILD_PROJECTS
else
    projs=$proj
fi

# Clone all the kappnav repos needed for build, if not already done
cd ..
for p in $projs; do
    if [ ! -d $p ]; then
        git clone https://github.com/kappnav/$p.git
    fi
done
cd -

# now build all projects
for p in $projs; do
    cd ../$p ; ./build.sh; cd -
done
