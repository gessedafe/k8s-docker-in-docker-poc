# ======================================
# Forwards cluster ports
# ======================================
kubectl port-forward service/elk-service 5601:5601 9600:9600 9200:9200 5044:5044

