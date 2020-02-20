#!/bin/bash
####################################################
#
# setupKAppNavTestEnv.sh for Kubernetes Application Navigator
#
####################################################

# check if user wants help
if [ "$#" -lt 5 ] || [  x$1 = 'x' ] || [  x$1 = x'?' ] || [  x$1 = x'--?' ] || [  x$1 = x'-?' ] || [  x$1 = x'--help'  ] || [  x$1 = x'help' ]; then
    echo "================================================================"
    echo "===> Note: this script is for use for IBM Development only! <==="
    echo "================================================================"
    echo "This script required 5 positional parameters"
    echo "Syntax: setupTestEnv.sh <platformURL> <platformUsername> <platformPassword> <platform> <dockerUsername>"
    echo
    echo "Where:"
    echo
    echo "   <platformURL> specifies the target URL"
    echo "   <platformUsername> specifies the target username"
    echo "   <platformPassword> specifies the target password"
    echo "   <platform> specifies one of: okd, ocp, minishift or minikube. Default is okd"
    echo "   <dockerUsername> specifies your docker username"
    echo
    exit 0
fi
    
# get positional parms
platformURL=$1
platformUsername=$2
platformPassword=$3
platform=$4
dockerID=$5

if [ x$platform = 'xminikube' ] ; then
    kubectl=$(kubectl)
    if [ $? -ne 0 ]; then
        echo "Error: kubectl not found. Make sure minikube is running."
        echo ""
        exit 1
    fi
else 
    # make sure to logout first, in case it already login to different platform
    oc logout
    # login to target platform
    echo "oc login -u $platformUsername -p $platformPassword $platformURL"
    oc login -u $platformUsername -p $platformPassword $platformURL
    if [ $? -eq 0 ]; then
        echo "########## OC login successfully. ##########"
    else
        echo "########## OC login failed, exiting. ##########"
        exit 1
    fi
fi

# At least check if previous KAppNav already install on user namespace
# If there is then uninstall first as having 2 instances install on same platform won't work well

# check if KAppNav has been installed using docker id namespace
./test/isDeployed.sh $dockerID
if [ $? -eq 0 ]; then
    echo "KAppNav already installed on namespace $dockerID"
    echo "Uninstalling KAppNav from $dockerID namespace"
    kubectl delete -f ../operator/kappnav-delete-CR.yaml -n $dockerID --now
    kubectl delete -f ../operator/kappnav-delete.yaml -n $dockerID
    kubectl delete namespace $dockerID
    if [ $? -eq 0 ]; then
        echo "########## Uninstall successfully. ##########"
    else 
        echo "########## Uninstall failed, exiting ##########"
        exit 1
    fi
fi

# check if KAppNav has been installed on kappnav namespace
# because if either AppNav or KAppNav already install on the platform you are using then thing won't work well
./test/isDeployed.sh kappnav
if [ $? -eq 0 ]; then
    echo "KAppNav already installed on namespace kappnav"
    echo "Uninstalling KAppNav from kappnav namespace"
    ./uninstall.sh
    if [ $? -eq 0 ]; then
        echo "########## Uninstall successfully. ##########"
    else 
        echo "########## Uninstall failed, exiting ##########"
        exit 1
    fi
fi

# build kappnav
echo "########## Building KAppNav ########## "
./build.sh
if [ $? -eq 0 ]; then
    echo "########## Build successfully. ##########"
else
    echo "########## Build failed, exiting. ##########"
    exit 1
fi

# push all images to docker hub
echo "########## Pushing all KAppNav images to docker hub of $dockerID ########## "
./pushimages.sh $dockerID
if [ $? -eq 0 ]; then
    echo "########## Pushed KAppNav images successfully. ##########"
else
    echo "########## Pushed KAppNav images failed, exiting. ##########"
    exit 1
fi

# installing to target platform
./install.sh $dockerID $platform
if [ $? -eq 0 ]; then
    echo "########## Install successfully. ##########"
else
    echo "########## Install failed, exiting. ##########"
    exit 1
fi

# check to make sure KAppNav healthy
./test/isKAppNavHealthy.sh kappnav
if [ $? -ne 0 ]; then
    echo "########## isKAppNavHealthy failed, exiting ##########"
    exit 1
fi

# check to hit kappnavui url
./test/isKappnavUIOK.sh kappnav $platform
if [ $? -ne 0 ]; then
    echo "########## isKappnavUIOK failed, exiting ##########"
    exit 1
fi

# install sample stocktrader application
./test/installStocktrader.sh kappnav
if [ $? -ne 0 ]; then
    echo "########## installStocktrader failed, exiting ##########"
    exit 1
fi

# install sample bookinfo application
./test/installBookinfo.sh kappnav
if [ $? -ne 0 ]; then
    echo "########## installBookinfo failed, exiting ##########"
    exit 1
fi

# install websphere liberty in container
./test/installLibertyInContainer.sh kappnav
if [ $? -ne 0 ]; then
    echo "########## installLibertyInContainer failed, exiting ##########"
    exit 1
fi

# test to make sure adminCenter url OK
# If do not want to launch the adminCenter, do not pass in true
./test/isAdminCenterUIOK.sh kappnav $platform

# launch kappnav ui to do UI manual test with the test env setup
# If do not want to launch the KAppNavUI, do not pass in true
./test/isKappnavUIOK.sh kappnav $platform true

exit 0











