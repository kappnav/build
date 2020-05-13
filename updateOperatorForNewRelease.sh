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
git branch | grep updateOperatorForNewRelease
if [ $? -eq 0 ]; then
    git checkout updateOperatorForNewRelease
else
    git checkout -b updateOperatorForNewRelease
fi

# create a dir for the new release and update the contents of the latest dir
. ../build/version.sh
newdir="releases/$VERSION"
mkdir $newdir
cat kappnav.yaml | sed "s|KAPPNAV_VERSION|$VERSION|" > $newdir/kappnav.yaml
cat kappnav-delete.yaml | sed "s|KAPPNAV_VERSION|$VERSION|" > $newdir/kappnav-delete.yaml
cat kappnav-delete-CR.yaml | sed "s|KAPPNAV_VERSION|$VERSION|" > $newdir/kappnav-delete-CR.yaml
cp $newdir/*.yaml releases/latest

# update operator origin
git add .
git commit -m "Update release names in operator yaml files"
if [ $? -eq 0 ]; then
    git push origin updateOperatorForNewRelease
    echo "Create a pull request for branch updateOperatorForNewRelease and merge it"
    echo "to master."
    read -p "Press enter/return after you have merged to master..." wait
else
    echo "Operator yaml files already up-to-date"
fi

# back to where we started
cd -
