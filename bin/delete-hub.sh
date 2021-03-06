SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

kubectl delete configmap -n jupyter jupyterhub-config
kubectl delete -f $SCRIPTPATH/../k8s-yaml/jupyterhub.yaml
kubectl delete configmap -n jupyter hub-status-service
kubectl delete configmap -n jupyter cull-idle-servers
kubectl delete configmap -n jupyter spawn-test

# Delete non-stopping pods:
# kubectl delete pod --force --grace-period=0 `kubectl get pods | grep Termin | grep jupyterhub | cut -d\  -f1`

# Wait for stop
echo "Waiting to stop existing pod..."
while kubectl get pods -n jupyter | grep '^jupyterhub-.*Running' ; do
    sleep 1
done
