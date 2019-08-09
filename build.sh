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

# Clone all the kappnav repos needed for build, if not already done
cd ..
if [ ! -d "init" ]; then
    git clone https://github.com/kappnav/init.git
fi
if [ ! -d "apis" ]; then
    git clone https://github.com/kappnav/apis.git
fi
if [ ! -d "controller" ]; then
    git clone https://github.com/kappnav/controller.git
fi
if [ ! -d "operator" ]; then
    git clone https://github.com/kappnav/operator.git
fi
if [ ! -d "ui" ]; then
    git clone https://github.com/kappnav/ui.git
fi
cd -

cd ../init ; ./build.sh; cd -
cd ../operator; ./build.sh; cd -
cd ../ui; ./build.sh; cd - 
cd ../apis; ./build.sh; cd - 
cd ../controller; ./build.sh; cd -