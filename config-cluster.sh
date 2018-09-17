# ======================================
# ENV VARS
# ======================================
DIND_CLUSTER_STARTUP_FILE=./vendor_kubeadm-dind-cluster/fixed/dind-cluster-v1.11-gessedafe.sh


# ======================================
# Building ELK Docker custom image
# ======================================
docker build ./configs/elk-docker-image-no-ssl --tag gessedafe/elk:1.0.0


# ======================================
# Cloning and changing the startup file to
# activate the audit logging feature
# ======================================
cp ./vendor_kubeadm-dind-cluster/fixed/dind-cluster-v1.11.sh $DIND_CLUSTER_STARTUP_FILE
sed -i  '' 's/{CoreDNS: false}/{CoreDNS: false, Auditing: true}/g' $DIND_CLUSTER_STARTUP_FILE


# ======================================
# Starting the cluster
# ======================================
$DIND_CLUSTER_STARTUP_FILE up


# ======================================
# Discovering master node's container
# ======================================
DIND_CLUSTER_MASTER_CONTAINER=`docker ps | grep master | awk '{print $1}'`


# ======================================
# Copying filebeat config to master
# container
# ======================================
docker cp ./filebeat-docker/filebeat.yml $DIND_CLUSTER_MASTER_CONTAINER:/usr/share/filebeat/filebeat.yml


# ======================================
# Deploying ELK
# ======================================
kubectl apply -f ./configs/elk.yml


# ======================================
# Deploying Filebeat
# ======================================
kubectl apply -f ./configs/filebeat-deamonset.yaml


# ======================================
# Forwarding cluster ports
# ======================================
./configs/elk-port-forwarding.sh


