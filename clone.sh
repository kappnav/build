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
# clone all development directories except website

# core
git clone https://github.com/kappnav/apis.git
git clone https://github.com/kappnav/init.git
git clone https://github.com/kappnav/operator.git
git clone https://github.com/kappnav/ui.git
git clone https://github.com/kappnav/controller.git

# samples
git clone https://github.com/kappnav/samples.git
