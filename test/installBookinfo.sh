isKAppNav=$1

echo "kubectl create namespace bookinfo"
kubectl create namespace bookinfo

if [ x$isKAppNav == 'x' ]; then
    echo "kubectl apply -f tmpbuild/samples/bookinfo -n bookinfo"
    kubectl apply -f tmpbuild/samples/bookinfo -n bookinfo
else
    echo "kubectl apply -f ../../samples/bookinfo -n bookinfo"
    kubectl apply -f ../samples/bookinfo -n bookinfo
fi

if [ $? -eq 0 ]; then
    echo "########## Bookinfo sample application installed successfully ##########"
else 
    echo "########## Failed to install bookinfo sample application ##########"
    exit 1
fi
