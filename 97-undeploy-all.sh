# ======================================
# Undeploys elk and filebeat
# ======================================
kubectl delete service elk-service

kubectl delete deployment elk-deployment

kubectl delete daemonset filebeat