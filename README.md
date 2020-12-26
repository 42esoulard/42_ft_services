# 42_ft_services
Clusturing a docker-compose application and deploying it with Kubernetes.

A multi-service cluster, with each service running in a dedicated container, all under Alpine Linux. 

Contains : 
  - The Kubernetes web dashboard to check on containers.
  - A WordPress website listening on port 5050, which will work with a MySQL database. Both services have to run in separate containers.
  - phpMyAdmin, listening on port 5000 and linked with the MySQL database.
  - A container with a nginx server listening on ports 80 and 443. 
  - A FTPS server listening on port 21.
  - A Grafana platform, listening on port 3000, linked with an InfluxDB database. Grafana will be monitoring all your containers. You must create one dashboard
per service. InfluxDB and grafana will be in two distincts containers.
  - In case of a crash or stop of one of the two database containers, you will have to
make shure the data persist.
  - ssh access to the nginx container 
  - restart of containers if they crash

#################################################################################################
  - START MINIKUBE: minikube start
  - DASHBOARD: minikube dashboard
  - OPEN SERVICE: minikube service SERVICE_NAME
  - PODS INFO: kubectl get pods
  - SSH: ssh admin@$(minikube ip) -p 400

  - DELETE CONTAINER: kubectl exec -it $(kubectl get pods | grep POD_NAME | cut -d" " -f1) -c CONTAINER_NAME -- /bin/sh -c "kill 1"
  - DELETE POD: kubectl delete POD_NAME

  -CLEAN: minikube delete && rm ./srcs/mysql/wordpresscp.sql ./srcs/ftps/startcp.sh ./srcs/yaml/telegrafcp.yaml ./srcs/yaml/telegrafcp.conf ./srcs/nginx/indexcp.html ./srcs/grafana/startcp.sh 
#################################################################################################
