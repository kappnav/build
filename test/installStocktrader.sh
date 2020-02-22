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

echo "kubectl create namespace stocktrader"
kubectl create namespace stocktrader

echo "kubectl apply -f $stocktraderPath -n stocktrader"
kubectl apply -f $stocktraderPath -n stocktrader

if [ $? -eq 0 ]; then
    # update stocktrader namespace to include all other application namespace that should show up under stock trader component view
    echo "kubectl annotate Application stock-trader kappnav.component.namespaces=twas,liberty,localliberty -n stocktrader --overwrite"
    kubectl annotate Application stock-trader kappnav.component.namespaces=twas,liberty,localliberty -n stocktrader --overwrite
    echo "########## Stocktrader sample application installed successfully ##########"
else 
    echo "########## Failed to install stocktrader sample application ##########"
    exit 1
fi