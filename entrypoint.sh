#!/bin/sh

set -e

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config


counter=0
result="$(kubectl get job "$*" -o jsonpath={.status.succeeded})"
while [  "$result" = "0" -a $counter -lt 4 ]
do
  sleep 5
  result="$(kubectl get job "$*" -o jsonpath={.status.succeeded})"
  ((counter++))
  echo $counter
  echo "$result"
done

if [ "$result" = "0" ]
then
exit 1
fi