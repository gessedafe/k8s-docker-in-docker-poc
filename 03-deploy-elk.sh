# ======================================
# Builds the ELK Docker custom image
# ======================================
docker build ./configs/elk-docker-image-no-ssl --tag gessedafe/elk:1.0.0.7


# ======================================
# Pushes the ELK image into Docker Hub
# ======================================
docker push gessedafe/elk:1.0.0.7


# ======================================
# Deploys ELK
# ======================================
kubectl apply -f ./elk/elk-deploy-service.yml


