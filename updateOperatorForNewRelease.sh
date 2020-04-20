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
# Update operator to create a new releases dir and make the new release the lastest release

# create the branch for the update
cd ../operator
git checkout master
git pull
git checkout -b updateOperatorForNewRelease

# create a dir for the new release and update the contents of the latest dir
. ./version.sh
newdir="releases/$VERSION"
mkdir $newdir
cp kappnav.yaml kappnav-delete.yaml kappnav-delete-CR.yaml $newdir
cp -r $newdir releases/lastest

# update operator origin
git add .
git commit -m "Update release names in operator yaml files"
git push origin updateOperatorForNewRelease
echo "Create a pull request for branch updateOperatorForNewRelease and merge it"
echo "to master."
read -p "Press enter/return after you have merged to master..." wait

# back to where we started
cd -
