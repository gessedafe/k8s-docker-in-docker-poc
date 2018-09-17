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
# Clones and changes the config file
# file to setup audit policies
# ======================================
DIND_CLUSTER_CONFIG_FILE=./vendor_kubeadm-dind-cluster/config.sh
cp $DIND_CLUSTER_CONFIG_FILE.tmpl $DIND_CLUSTER_CONFIG_FILE
sed -i  '' 's/# APISERVER_xxx_yyy=zzz/APISERVER_audit_policy_file=\/etc\/kubernetes\/audit-policy.yaml/g' $DIND_CLUSTER_CONFIG_FILE


# ======================================
# Changes the cluster startup script
# to send the audit-policy file to the
# master node container
# ======================================
DIND_CLUSTER_SH_FILE=./vendor_kubeadm-dind-cluster/dind-cluster.sh
cp $DIND_CLUSTER_SH_FILE.tmpl $DIND_CLUSTER_SH_FILE
sed -i '' 's/docker exec -i "$master_name"/docker exec "$master_name" mkdir \/etc\/kubernetes\
  docker cp .\/configs\/audit-policy.yaml "$master_name":\/etc\/kubernetes\/audit-policy.yaml\
  docker exec -i "$master_name"/g' $DIND_CLUSTER_SH_FILE


