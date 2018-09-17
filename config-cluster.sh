#./kubeadm-dind-cluster/kubeadm-dind-cluster/fixed/dind-cluster-v1.11.sh
kubectl apply -f ./configs/elk.yml
kubectl apply -f ./configs/filebeat-deamonset.yaml
sleep 90s
./configs/elk-port-forwarding.sh


