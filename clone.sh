#!/bin/bash
#*****************************************************************
#*
#* Copyright 2019, 2020 IBM Corporation
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
# clone all development directories except website
arg=$1 
projs='README build samples apis controller operator ui' 

# make sure running in build directory 
if [ $(echo $PWD | awk '{ n=split($0,d,"/"); print d[n] }') != 'build' ]; then 
    echo 'Error: $kappnav/build dir must be current dir.'
    echo ''
    arg="--?"
fi

if [ x$arg == x'--?' ]; then
	echo Clones all kAppNav projects.
	echo 
	echo syntax:
	echo
	echo "clone.sh" 
    exit 0
fi

# clone all projects 
for p in $projs; do 
    git clone https://github.com/kappnav/$p.git ../$p 
done 