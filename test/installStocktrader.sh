#!/bin/bash
####################################################
#
# installStocktrader.sh <stocktrader sample path>
#
####################################################

if [ "$#" -lt 1 ] || [  x$1 = 'x' ] || [  x$1 = x'?' ] || [  x$1 = x'--?' ] || [  x$1 = x'-?' ] || [  x$1 = x'--help'  ] || [  x$1 = x'help' ]; then
  echo Syntax: installStocktrader.sh \<stocktrader sample path\>
    echo "Where:"
    echo "   <stocktrader sample path> specifies the path where stocktrader sample located"
  exit 1
fi

stocktraderPath=$1

echo "kubectl create namespace stock-trader"
kubectl create namespace stock-trader

echo "kubectl apply -f $stocktraderPath -n stock-trader"
kubectl apply -f $stocktraderPath -n stock-trader

if [ $? -eq 0 ]; then
    # update stocktrader namespace to include all other application namespace that should show up under stock trader component view
    echo "kubectl annotate Application stock-trader kappnav.component.namespaces=twas,liberty,localliberty -n stock-trader --overwrite"
    kubectl annotate Application stock-trader kappnav.component.namespaces=twas,liberty,localliberty,appmetrics-dash -n stock-trader --overwrite
    echo "########## Stocktrader sample application installed successfully ##########"
else 
    echo "########## Failed to install stocktrader sample application ##########"
    exit 1
fi