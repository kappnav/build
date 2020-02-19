isKAppNav=$1

echo "kubectl create namespace localliberty"
kubectl create namespace localliberty

if [ x$isKAppNav == 'x' ]; then
    echo "kubectl apply -f tmpbuild/test/twas-liberty/kappnav-websphere-liberty -n localliberty"
    kubectl apply -f tmpbuild/test/twas-liberty/kappnav-websphere-liberty.yaml -n localliberty
else 
    echo "kubectl apply -f ../test/twas-liberty/kappnav-websphere-liberty -n localliberty"
    kubectl apply -f test/twas-liberty/kappnav-websphere-liberty.yaml -n localliberty
fi

if [ $? -eq 0 ]; then
    echo "########## WebSphere Liberty in container installed successfully ##########"
else 
    echo "########## Failed to install WebSphere Liberty in container ##########"
    exit 1
fi
