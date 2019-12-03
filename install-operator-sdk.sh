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

set -o errexit
set -o nounset

if [ -x "$(command -v operator-sdk)" ]; then
  operator-sdk version
  exit 0
fi

DEFAULT_RELEASE_VERSION=v0.10.0
RELEASE_VERSION=${1:-$DEFAULT_RELEASE_VERSION}

if [ "$(uname)" == "Darwin" ]; then
  binary_url="https://github.com/operator-framework/operator-sdk/releases/download/$RELEASE_VERSION/operator-sdk-$RELEASE_VERSION-x86_64-apple-darwin"
else
  binary_url="https://github.com/operator-framework/operator-sdk/releases/download/$RELEASE_VERSION/operator-sdk-$RELEASE_VERSION-x86_64-linux-gnu"
fi

echo "Installing operator-sdk version $RELEASE_VERSION"
curl -L -o operator-sdk $binary_url
chmod +x operator-sdk
sudo mv operator-sdk /usr/local/bin/operator-sdk

operator-sdk version