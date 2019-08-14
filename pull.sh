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

if [ -d ../init ]; then
    echo Pulling init repo
    cd ../init ; git pull; cd -
fi
if [ -d ../operator ]; then
    echo Pulling operator repo
    cd ../operator; git pull; cd -
fi
if [ -d ../ui ]; then
    echo Pulling ui repo
    cd ../ui; git pull; cd -
fi
if [ -d ../apis ]; then
    echo Pulling apis repo
    cd ../apis; git pull; cd - 
fi
if [ -d ../controller ]; then
    echo Pulling controller repo
    cd ../controller; git pull; cd -
fi
if [ -d ../readme ]; then
    echo Pulling readme repo
    cd ../readme; git pull; cd -
fi
if [ -d ../samples ]; then
    echo Pulling samples repo
    cd ../samples; git pull; cd -
fi
echo Pulling build repo
git pull