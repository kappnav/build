if [ "$#" -lt 1 ] || [  x$1 = 'x' ] || [  x$1 = x'?' ] || [  x$1 = x'--?' ] || [  x$1 = x'-?' ] || [  x$1 = x'--help'  ] || [  x$1 = x'help' ]; then
  echo Syntax: isKAppNavHealthy.sh \<namespace\>
    echo "Where:"
    echo "   <namespace> specifies the namespace where AppNav is installed."
  exit 1
fi

namespace=$1

# get all KAppNav pods
echo "kubectl get pods -n $namespace --no-headers -o custom-columns=NAME:.metadata.name"
kappnavPods=$(kubectl get pods -n $namespace --no-headers -o custom-columns=NAME:.metadata.name)
echo $kappnavPods
kappnavPodsArray=( $kappnavPods )
kappnavPodsLen="${#kappnavPodsArray[@]}"

# check to make sure all 4 KAppNav pods created
count=0
numPods=4
if [ x$namespace == x'kappnav' ]; then
  numPods=3
fi

while [ $kappnavPodsLen -ne $numPods ]
do
   if [ $count -eq 12 ]; then 
      exit 1
   else
      echo "kubectl get pods -n $namespace --no-headers -o custom-columns=NAME:.metadata.name"
      kappnavPods=$(kubectl get pods -n $namespace --no-headers -o custom-columns=NAME:.metadata.name)
      kappnavPodsArray=( $kappnavPods )
      kappnavPodsLen="${#kappnavPodsArray[@]}"
      if [ $kappnavPodsLen -ne $numPods ]; then
        # check to make sure all kappnav pods created for 1 minutes at the most with 5s delay in between checking
        sleep 5
      fi
      count=$((count+1))
   fi
done

echo $kappnavPods
# check all KAppNav pods until all pods status true
for kappnavPod in $kappnavPods
do
  status="false"
  count=0
  while [ "$status" = "false" ] 
  do 
      # check to make sure the apps created for 10 minutes at the most with 5s delay in between checking
      if [ $count -eq 120 ]; then
          exit 1
      else
          echo "kubectl get pods $kappnavPod -n $namespace --no-headers -o custom-columns=Ready:status.containerStatuses[0].ready"
          status=$(kubectl get pods $kappnavPod -n $namespace --no-headers -o custom-columns=Ready:status.containerStatuses[0].ready)
          if [ "$status" = "false" ]; then
            sleep 5
          fi
          count=$((count+1))
      fi
      echo "Status : $status"
  done
done

echo "########## KAppNav pods are healthy ##########"


  


