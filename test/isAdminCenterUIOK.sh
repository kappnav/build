if [ "$#" -lt 2 ] || [  x$1 = 'x' ] || [  x$1 = x'?' ] || [  x$1 = x'--?' ] || [  x$1 = x'-?' ] || [  x$1 = x'--help'  ] || [  x$1 = x'help' ]; then
    echo "Syntax: isAdminCenterUIOK.sh <namespace> <platform> [true|false]"
    echo "Where:"
    echo "   <namespace> specifies the namespace where AppNav is installed."
    echo "   <platform> specifies one of: okd, ocp or minishift. Default is okd."
    echo "   optional: [true|false] true will launch the kappnavui page."
  exit 1
fi

namespace=$1
platform=$2
launch=$3

# test to hit Liberty adminCenter ui
if [ x$platform != 'xminikube' ] ; then
    echo "kubectl get route -n $namespace -o=jsonpath={@.items[0].spec.host}"
    host=$(kubectl get route -n $namespace -o=jsonpath={@.items[0].spec.host})
    if [ -z host ]; then
        echo "Could not retrieve kappnavui host from route. Confirm install is correct."
        exit 1 
    fi 
    url="https://$host/adminCenter/"

    curl=$(curl $url --insecure >/dev/null 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Error: $url not responding. Check that initialization is complete and successful."
        echo ""
        exit 1
    fi
fi

echo "########## Liberty AdminCenter UI is OK ##########"

if [ "$launch" = "true" ]; then
  open $url
  echo "########## Liberty AdminCenter UI is launched at url $url ##########"
fi


