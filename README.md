# build
Builds Docker images for entire kAppNav project.

Prereq: docker

Procedure:

1. `md kappnav`
2. `cd kappnav`
3. `git clone https://github.com/kappnav/build.git`
4. `cd build` 
5. `./clone.sh`
6. `./build.sh`

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
| pull.sh | Pull all kAppNav projects. |
| pushimages.sh \<docker-org\> [\<project\>] | Push all kAppNav images or specified project's image to target dockerhub organization. Project names are ui, apis, operator, etc | 
| status.sh | Display current git status of all kAppNav projects. | 
| uninstall.sh | Uninstall kAppNav from current Kubernetes config. |
