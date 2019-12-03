# build
Builds Docker images for entire kAppNav project.

Prereq: Docker, Operator SDK (see install-operator-sdk.sh script)

Procedure:

1. md kappnav
2. cd kappnav
3. git clone https://github.com/kappnav/build.git
4. cd build 
5. ./clone.sh
6. ./build.sh

# install 

See https://github.com/kappnav/README#install

# local development 

The following scripts are supplied to help with local development: 

| Script | Description | 
|--------|-------|
| branches.sh | Displays current branch of all kAppNav projects. | 
| build.sh [\<project\>] | Builds all kAppNav projects or specified project. Project names are ui, apis, operator, etc|
| checkout.sh \<branch\> | Checkout specified branch across all kAppNav projects. |
| clone.sh | Clone all kAppNav projects. | 
| install.sh  \<docker-org\>| Install kAppNav images to current Kubernetes config from specified dockerhub organization. |
| install-operator-sdk.sh [\<release-version\>] | Install the Operator SDK (if not currently installed). The default is v0.10.0 which is required to build the kAppNav operator. See prereqs for the Operator SDK here: https://github.com/operator-framework/operator-sdk. Go v1.13 is recommended for compilation of the kAppNav operator code. |
| pull.sh | Pull all kAppNav projects. |
| pushimages.sh \<docker-org\> [\<project\>] | Push all kAppNav images or specified project's image to target dockerhub organization. Project names are ui, apis, operator, etc | 
| status.sh | Display current git status of all kAppNav projects. | 
| uninstall.sh | Uninstall kAppNav from current Kubernetes config. |
