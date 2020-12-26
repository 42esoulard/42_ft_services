#!/bin/bash

cyan=$'\033[1;36m'
mag=$'\033[1;35m'
red=$'\033[1;31m'
w=$'\033[1;37m'

export MINIKUBE_HOME="/goinfre/esoulard/"

echo "${mag} -------------------->${mag}! MAKE SURE DOCKER IS RUNNING ON YOUR MACHINE !<--------------------${w}"

echo "${mag} 	  -------------------->${mag}Checking ${cyan}BREW ${mag}install...<--------------------${w}"
which -s brew
if [[ $? != 0 ]] ; then
    rm -rf $HOME/.brew && git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew && export PATH=$HOME/.brew/bin:$PATH && brew update && echo "export PATH=$HOME/.brew/bin:$PATH" >> ~/.zshrc &> /dev/null
fi

echo "${mag}	-------------------->${mag}Checking ${cyan}MINIKUBE ${mag}install...<--------------------${w}"
which -s minikube
if [[ $? != 0 ]] ; then
	brew install minikube
fi

echo "${mag}	  -------------------->${mag}Configuring ${cyan}MINIKUBE${mag}...<--------------------${w}"
minikube config set vm-driver virtualbox
minikube delete
minikube start --extra-config=apiserver.service-node-port-range=2-32767 --extra-config=kubelet.authorization-mode=AlwaysAllow

minikube addons enable ingress
minikube addons enable dashboard
minikube addons enable metrics-server

MINIKUBE_IP=$(minikube ip)
eval $(minikube docker-env)

echo "${mag}   -------------------->${mag}Preparing some ${cyan}FILE SOUP ${mag}...<--------------------${w}"
cp ./srcs/mysql/wordpress.sql ./srcs/mysql/wordpresscp.sql
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" ./srcs/mysql/wordpresscp.sql
cp ./srcs/ftps/start.sh ./srcs/ftps/startcp.sh
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" ./srcs/ftps/startcp.sh
cp ./srcs/yaml/telegraf.yaml ./srcs/yaml/telegrafcp.yaml
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" ./srcs/yaml/telegrafcp.yaml
cp ./srcs/telegraf/telegraf.conf ./srcs/yaml/telegrafcp.conf
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" ./srcs/yaml/telegrafcp.conf
cp ./srcs/nginx/index.html ./srcs/nginx/indexcp.html
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" ./srcs/nginx/indexcp.html
cp ./srcs/grafana/start.sh ./srcs/grafana/startcp.sh
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" ./srcs/grafana/startcp.sh

echo "${mag} 		  -------------------->${mag}Building ${cyan}DOCKER IMAGES${mag}...<--------------------${w}"
echo "${cyan}----------------------------------------------------------------------------------------${w}"
echo "${mag} 		  -------------------->${mag}Building ${cyan}NGINX IMAGE${mag}...<--------------------${w}"
docker build ./srcs/nginx/ -t nginx_alpine_esou
echo "${mag}		------------>${cyan}NGINX IMAGE${mag} built!<------------${w}"
echo "${mag} 		  -------------------->${mag}Building ${cyan}MYSQL IMAGE${mag}...<--------------------${w}"
docker build ./srcs/mysql/ -t mysql_alpine_esou
echo "${mag}		------------>${cyan}MYSQL IMAGE${mag} built!<------------${w}"
echo "${mag} 	  -------------------->${mag}Building ${cyan}WORDPRESS IMAGE${mag}...<--------------------${w}"
docker build ./srcs/wordpress/ -t wordpress_alpine_esou
echo "${mag}		------------>${cyan}WORDPRESS IMAGE${mag} built!<------------${w}"
echo "${mag} 	  -------------------->${mag}Building ${cyan}PHPMYADMIN IMAGE${mag}...<--------------------${w}"
docker build ./srcs/phpmyadmin/ -t phpmyadmin_alpine_esou
echo "${mag}		------------>${cyan}PHPMYADMIN IMAGE${mag} built!<------------${w}"
echo "${mag}   	   -------------------->${mag}Building ${cyan}FTPS IMAGE${mag}...<--------------------${w}"
docker build ./srcs/ftps/ -t ftps_alpine_esou
echo "${mag}			------------>${cyan}FTPS IMAGE${mag} built!<------------${w}"
echo "${mag}  	  -------------------->${mag}Building ${cyan}INFLUXDB IMAGE${mag}...<--------------------${w}"
docker build ./srcs/influxdb/ -t influxdb_alpine_esou
echo "${mag}		------------>${cyan}INFLUXDB IMAGE${mag} built!<------------${w}"
echo "${mag}  	  -------------------->${mag}Building ${cyan}TELEGRAF IMAGE${mag}...<--------------------${w}"
docker build ./srcs/telegraf/ -t telegraf_alpine_esou
echo "${mag}		------------>${cyan}TELEGRAF IMAGE${mag} built!<------------${w}"
echo "${mag}  	 -------------------->${mag}Building ${cyan}GRAFANA IMAGE${mag}...<--------------------${w}"
docker build ./srcs/grafana/ -t grafana_alpine_esou
echo "${mag}		------------>${cyan}GRAFANA IMAGE${mag} built!<------------${w}"

echo "${mag}	------------>${mag}Working on one dam' fine ${cyan}KUBERTNETES DEPLOYMENT${mag}...<------------${w}"
kubectl apply -f ./srcs/yaml/nginx.yaml
kubectl apply -f ./srcs/yaml/mysql.yaml
kubectl apply -f ./srcs/yaml/wordpress.yaml
kubectl apply -f ./srcs/yaml/ingress.yaml
kubectl apply -f ./srcs/yaml/phpmyadmin.yaml
kubectl apply -f ./srcs/yaml/ftps.yaml
kubectl apply -f ./srcs/yaml/influxdb.yaml
kubectl apply -f ./srcs/yaml/telegrafcp.yaml
kubectl apply -f ./srcs/yaml/grafana.yaml

echo "${mag} 	 ------------------>${mag}Waiting for ${cyan}PODS ${mag}to get busy...<------------------${w}"
while [[ $(kubectl get pods -l app=mysql -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
	sleep 5;
done
sleep 30
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/mysql/wordpresscp.sql

echo "${mag}   	    -------------------->${mag}Almost there...<--------------------${w}"
while [[ $(kubectl get pods -l app=grafana -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
	sleep 5;
done
chmod 755 ./srcs/grafana/startcp.sh
sh ./srcs/grafana/startcp.sh

echo "             .-') _                .-')       ('-.    _  .-')         ('-.                            ('-.     .-')"  ;
echo "            (  OO) )              ( OO ).   _(  OO)  ( \( -O )      _(OO  )_                        _(  OO)   ( OO ). " ;
echo "   ,------. /     '._            (_)---\_) (,------.  ,------.  ,--(_/   ,. \  ,-.-')     .-----.  (,------. (_)---\_) ";
echo "('-| _.---' |'--...__)           /    _ |   |  .---'  |   /'. ' \   \   /(__/  |0  |OO)  '  .--./   |  .---' /    _ |  ";
echo "(OO|(_\     '--.  .--'           \  :` `.   |  |      |  /  | |  \   \ /   /   |  |  \   |  |('-.   |  |     \  :` `.  ";
echo "/  |  '--.     |  |      ('-.     '..''.)  (|  '--.   |  |_.' |   \   '   /,   |  |(_/  /_) |OO  ) (|  '--.   '..''.) ";
echo "\_)|  .--'     |  |     (OO  )_  .-._)   \  |  .--'   |  .  '.'    \     /__) ,|  |_.'  ||  |'-'|   |  .--'  .-._)   \ ";
echo "  \|  |_)      |  |    ,------.) \       /  |  '---.  |  |\  \      \   /    (_|  |    (_'  '--'\   |  '---. \       / ";
echo "   '--'        '--'    '------'   '-----'   '------'  '--' '--'      '-'       '--'       '-----'   '------'  '-----'  ";


echo $'\n'
echo "${mag}	-------------------->${cyan}DONE !\n${mag} Visit $(minikube ip) to find out all the ${cyan}FUN${mag} stuff we can do here."
echo $'\n\n'
echo "${mag}	------------> ${cyan}FUUUUUUUN.${w}"

#################################################################################################
####### DASHBOARD: minikube dashboard
####### OPEN SERVICE: minikube service SERVICE_NAME
####### PODS INFO: kubectl get pods
####### SSH: ssh admin@$(minikube ip) -p 400

####### DELETE CONTAINER: kubectl exec -it $(kubectl get pods | grep POD_NAME | cut -d" " -f1) -c CONTAINER_NAME -- /bin/sh -c "kill 1"
####### DELETE POD: kubectl delete POD_NAME

#######CLEAN: minikube delete && rm ./srcs/mysql/wordpresscp.sql ./srcs/ftps/startcp.sh ./srcs/yaml/telegrafcp.yaml ./srcs/yaml/telegrafcp.conf ./srcs/nginx/indexcp.html ./srcs/grafana/startcp.sh 
#################################################################################################
