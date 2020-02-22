#!/bin/bash
####################################################
#
# installBookinfo.sh <bookinfo sample path>
#
####################################################

if [ "$#" -lt 1 ] || [  x$1 = 'x' ] || [  x$1 = x'?' ] || [  x$1 = x'--?' ] || [  x$1 = x'-?' ] || [  x$1 = x'--help'  ] || [  x$1 = x'help' ]; then
  echo Syntax: installBookinfo.sh \<bookinfo sample path\>
    echo "Where:"
    echo "   <bookinfo sample path> specifies the path where bookinfo sample located"
  exit 1
fi

bookinfoPath=$1

echo "kubectl create namespace bookinfo"
kubectl create namespace bookinfo

echo "kubectl apply -f $bookinfoPath -n bookinfo"
kubectl apply -f $bookinfoPath -n bookinfo

if [ $? -eq 0 ]; then
    echo "########## Bookinfo sample application installed successfully ##########"
else 
    echo "########## Failed to install bookinfo sample application ##########"
    exit 1
fi
