#!/bin/bash

handleParams() {
    # check if user wants help
    if [ "$#" -lt 5 ] || [  x$1 = 'x' ] || [  x$1 = x'?' ] || [  x$1 = x'--?' ] || [  x$1 = x'-?' ] || [  x$1 = x'--help'  ] || [  x$1 = x'help' ]; then
        echo "This script requires 5 positional parameters"
        echo "Syntax: setupKAppNavLib.sh <platformURL> <platformUsername> <platformPassword> <platform> <dockerUsername> [-b] [-p]"
        echo
        echo "Where:"
        echo
        echo "   <platformURL>  specifies the target URL"
        echo "   <platformUsername>  specifies the target username"
        echo "   <platformPassword> s pecifies the target password"
        echo "   <platform>  specifies one of: okd, ocp, minishift or minikube. Default is okd"
        echo "   <dockerUsername> specifies your docker username"
        echo "   optional: -b  requests a build to be performed"
        echo "   optional: -p  requests images to be pushed to the user's Docker Hub space"
        echo "   optional: <repo1,repo2,repo3>  list of local repos to use separated by comma."
        echo
        exit 0
    fi

    # get positional parms
    platformURL=$1
    platformUsername=$2
    platformPassword=$3
    platform=$4
    dockerID=$5

    # set defaults
    doBuild=false
    
    allBuildArguments=("$@")

    for ((index=0; index < ${#allBuildArguments[@]}; index++)); do
        if [ ${allBuildArguments[index]} = '-r' ]; then
            reposArg=${allBuildArguments[index+1]}
            if [ "$reposArg" = "" ]; then
                echo "Missing required argument for -r"
                exit 1 # exit script with error
            fi
            # parse the r option values
            IFS=',' read -r -a repos <<< "$reposArg"
        fi
    done


    # get optional params
    for o in $(echo $@); do
        if [ $o = '-b' ]; then
            doBuild=true
        fi
        if [ $o = '-p' ]; then
            doPush=true
        fi
    done
}

build() {
    echo "########## Build started on $(date)  ##########"
    if [ x$reposArg = 'x' ] || [ x$reposArg = "" ]; then
        ./build.sh
    else
        for repo in "${repos[@]}"; do
            ./build.sh $repo
            if [ $? -ne 0 ]; then
                echo "########## Error: build $repo failed ##########"
                exit 1
            fi
        done
    fi
    echo "########## Build completed on $(date)  ##########"
    echo
    echo
}

push() {
    echo "########## Pushimages started on $(date)  ##########"
    echo "########## Pushing all KAppNav images to docker hub of $dockerID ########## "
    if [ x$reposArg = 'x' ] || [ x$reposArg = "" ]; then
        ./pushimages.sh $dockerID
    else
        for repo in "${repos[@]}"; do
            ./pushimages.sh $dockerID $repo
            if [ $? -ne 0 ]; then
                echo "########## Pushed $repo images failed, exiting. ##########"
                exit 1
            fi            
        done
    fi
    echo "########## Pushimages completed on $(date)  ##########"
    echo
    echo
}

login() {
    if [ x$platform = 'xminikube' ] ; then
        kubectl=$(kubectl)
        if [ $? -ne 0 ]; then
            echo "Error: kubectl not found. Make sure minikube is running."
            echo ""
            exit 1
        fi
    else
        # login to target platform
        echo "########## Login started on $(date)  ##########"
        echo "oc login -u $platformUsername -p $platformPassword $platformURL"
        oc login -u $platformUsername -p $platformPassword $platformURL
        if [ $? -eq 0 ]; then
            echo "########## OC login successful ##########"
        else
            echo "########## OC login failed, exiting ##########"
            exit 1
        fi
        echo "########## Login completed on $(date)  ##########"
        echo
        echo
    fi
}

uninstall() {
    # check if KAppNav is already installed
    ./test/isDeployed.sh $oldNamespace
    if [ $? -eq 0 ]; then
        echo "Already installed in namespace $oldNamespace"
        echo "Uninstalling from $oldNamespace namespace"
        echo "########## uninstall started on $(date)  ##########"
        if [ $oldNamespace = "kappnav" ]; then
            ./uninstall.sh
            if [ $? -eq 0 ]; then
                echo "kubectl delete namespace $oldNamespace"
                kubectl delete namespace $oldNamespace
                echo "########## Uninstall successful ##########"
            else
                echo "########## Uninstall failed, exiting ##########"
                exit 1
            fi
        else
            echo "kubectl delete namespace $oldNamespace"
            kubectl delete namespace $oldNamespace
            if [ $? -eq 0 ]; then
                echo "########## Uninstall successful ##########"
            else
                echo "########## Uninstall failed, exiting ##########"
                exit 1
            fi
        fi 
        echo "########## Uninstall completed on $(date)  ##########"
    fi 
}

install() {
    echo "########## Install started on $(date)  ##########"
    ./install.sh $dockerID $platform $reposArg
    if [ $? -eq 0 ]; then
        echo "########## Install successfully. ##########"
    else
        echo "########## Install failed, exiting. ##########"
        exit 1
    fi
    echo "########## Install completed on $(date)  ##########"
    echo
    echo
}

ivt() {
    # check to make sure KAppNav is healthy
    numberOfPods=3
    echo "########## IVT started on $(date)  ##########"
    ./test/isKAppNavHealthy.sh kappnav $numberOfPods
    if [ $? -ne 0 ]; then
        echo "########## isKAppNavHealthy failed, exiting. ##########"
        exit 1
    fi
    
    # check to make sure KAppNav UI is responding
    ./test/isKappnavUIOK.sh kappnav $platform
    if [ $? -ne 0 ]; then
        echo "########## isKappnavUIOK failed, exiting. ##########"
        exit 1
    fi
    echo "########## IVT completed on $(date)  ##########"
    echo
    echo
}

addSamples() {
    echo "########## addSamples started on $(date)  ##########"
    # install sample stocktrader application
    ./test/installStocktrader.sh ../samples/stocktrader
    if [ $? -ne 0 ]; then
        echo "########## installStocktrader failed, exiting. ##########"
        exit 1
    fi
    
    # install sample bookinfo application
    ./test/installBookinfo.sh ../samples/bookinfo
    if [ $? -ne 0 ]; then
        echo "########## installBookinfo failed, exiting. ##########"
        exit 1
    fi
    echo "########## addSamples completed on $(date)  ##########"
    echo 
    echo
}
