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
# does git pull on all projects

arg=$1
# make sure running in build directory 
if [ $(echo $PWD | awk '{ n=split($0,d,"/"); print d[n] }') != 'build' ]; then 
    echo 'Error: $kappnav/build dir must be current dir.'
    echo ''
    arg="--?"
fi

if [ x$arg == x'--?' ]; then
	echo "Attempt git pull on all kAppNav projects, skipping any that do not exist: "
	echo ""
	echo ""
	echo "syntax:"
	echo ""
	echo "pull.sh"
	exit 1
fi

projs='README init samples apis controller operator ui build' 

for p in $projs; do 
    if [ -d ../$p ]; then
	    cd ../$p
	    echo Pulling $p repo 
	    git pull
    fi
done