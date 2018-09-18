# ======================================
# Discovers the name of master node's
# container
# ======================================
DIND_CLUSTER_MASTER_CONTAINER=`docker ps | grep master | awk '{print $1}'`


#docker cp ./configs/audit-policy.yaml $DIND_CLUSTER_MASTER_CONTAINER:/etc/kubernetes/audit/audit.yaml


# ======================================
# Copies filebeat config to master
# container
# ======================================
docker exec $DIND_CLUSTER_MASTER_CONTAINER mkdir /usr/share/filebeat
docker cp ./filebeat/filebeat.yml $DIND_CLUSTER_MASTER_CONTAINER:/usr/share/filebeat/filebeat.yml


# ======================================
# Builds the ELK Docker custom image
# ======================================
docker build ./configs/elk-docker-image-no-ssl --tag gessedafe/elk:1.0.0.4


# ======================================
# Pushes the ELK image into Docker Hub
# ======================================
docker push gessedafe/elk:1.0.0.4


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



