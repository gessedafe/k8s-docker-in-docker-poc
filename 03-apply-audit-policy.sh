# ======================================
# Discovers the name of master node's
# container
# ======================================
DIND_CLUSTER_MASTER_CONTAINER=`docker ps | grep master | awk '{print $1}'`


# ======================================
# Copies the audit policy file to the
# master container
# ======================================
docker cp ./configs/audit-policy.yaml $DIND_CLUSTER_MASTER_CONTAINER:/etc/kubernetes/audit/audit.yaml

# ======================================
# Executes a docker-in-docker restart
# of the kube-apiserver container
# ======================================
docker exec -it $DIND_CLUSTER_MASTER_CONTAINER /bin/bash






KUBEAPI_SERVER_CONTAINER=`docker ps | grep k8s_kube-apiserver_kube | awk '{print $1}'`
docker restart $KUBEAPI_SERVER_CONTAINER
> /var/log/kubernetes/audit/audit.log
tail -f /var/log/kubernetes/audit/audit.log

