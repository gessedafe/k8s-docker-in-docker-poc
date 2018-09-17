# ======================================
# Defines a path for the cluster startup
# custom script
# ======================================
DIND_CLUSTER_STARTUP_FILE=./vendor_kubeadm-dind-cluster/fixed/dind-cluster-v1.11-gessedafe.sh


# ======================================
# Clones and changes the cluster startup
# file to activate the audit logging
# feature
# ======================================
cp ./vendor_kubeadm-dind-cluster/fixed/dind-cluster-v1.11.sh $DIND_CLUSTER_STARTUP_FILE
sed -i  '' 's/{CoreDNS: false}/{CoreDNS: false, Auditing: true}/g' $DIND_CLUSTER_STARTUP_FILE


# ======================================
# Starts the cluster
# ======================================
$DIND_CLUSTER_STARTUP_FILE up


# ======================================
# Discovers the name of master node's
# container
# ======================================
DIND_CLUSTER_MASTER_CONTAINER=`docker ps | grep master | awk '{print $1}'`


# ======================================
# Copies filebeat config to master
# container
# ======================================
docker exec $DIND_CLUSTER_MASTER_CONTAINER mkdir /usr/share/filebeat
docker cp ./filebeat/filebeat.yml $DIND_CLUSTER_MASTER_CONTAINER:/usr/share/filebeat/filebeat.yml


# ======================================
# Builds the ELK Docker custom image
# ======================================
docker build ./configs/elk-docker-image-no-ssl --tag gessedafe/elk:1.0.0.1


# ======================================
# Pushes the ELK image into Docker Hub
# ======================================
docker push gessedafe/elk:1.0.0.1


# ======================================
# Deploys ELK
# ======================================
kubectl apply -f ./elk/elk-deploy-service.yml


# ======================================
# Creates a config map for filebeat
# ======================================
kubectl create configmap filebeat-config --from-file ./filebeat/filebeat.yml -o yaml --dry-run | kubectl apply -f -


# ======================================
# Deploys Filebeat
# ======================================
kubectl apply -f ./filebeat/filebeat-daemonset.yml


# ======================================
# Forwards cluster ports
# ======================================
./elk/elk-port-forwarding.sh


