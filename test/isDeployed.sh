if [ "$#" -lt 1 ] || [  x$1 = 'x' ] || [  x$1 = x'?' ] || [  x$1 = x'--?' ] || [  x$1 = x'-?' ] || [  x$1 = x'--help'  ] || [  x$1 = x'help' ]; then
  echo Syntax: isDeployed.sh \<namespace\> 
    echo "Where:"
    echo "   <namespace> specifies the namespace where KAppNav is installed."
  exit 1
fi

namespace=$1

echo "kubectl get Deployment -n $namespace --no-headers"
deployments=$(kubectl get Deployment -n $namespace --no-headers)
depLen=${#deployments}
if [ $depLen -ne 0 ]; then
    echo "Already installed"
    exit 0
else 
    echo "Not installed yet"
    exit 1
fi
