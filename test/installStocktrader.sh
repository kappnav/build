isKAppNav=$1

echo "kubectl create namespace stocktrader"
kubectl create namespace stocktrader

if [ x$isKAppNav == 'x' ]; then
    echo "kubectl apply -f tmpbuild/samples/stocktrader -n stocktrader"
    kubectl apply -f tmpbuild/samples/stocktrader -n stocktrader
else
    echo "kubectl apply -f ../../samples/stocktrader -n stocktrader"
    kubectl apply -f ../samples/stocktrader -n stocktrader
fi

if [ $? -eq 0 ]; then
    echo "kubectl annotate Application stock-trader kappnav.component.namespaces=twas,liberty,localliberty -n stocktrader --overwrite"
    kubectl annotate Application stock-trader kappnav.component.namespaces=twas,liberty,localliberty -n stocktrader --overwrite
    echo "########## Stocktrader sample application installed successfully ##########"
else 
    echo "########## Failed to install stocktrader sample application ##########"
    exit 1
fi