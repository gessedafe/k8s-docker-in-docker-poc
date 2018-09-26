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
