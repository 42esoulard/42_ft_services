#!/bin/sh
curl -s -H "Content-Type: application/json" \
    -XPOST http://MINIKUBE_IP:3000/api/datasources \
    -d @- << EOF
    {
        "name":"influxdb",
        "ordId": 1,
        "type":"influxdb",
        "url":"http://influxdb:8086",
        "password":"password",
        "user":"root",
        "access":"proxy",
        "basicAuth":false,
        "basicAuthUser": "root",
        "basicAuthPassword": "password",
        "database":"telegraf",
        "isDefault":false,
        "editable":false,
        "version": 1,
        "jsonData": {
            "timeInterval":"10s"
        }
    }
EOF

curl -s -H "Content-Type: application/json" \
-XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
-d @./srcs/grafana/dashboards/ftps.json

curl -s -H "Content-Type: application/json" \
-XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
-d @./srcs/grafana/dashboards/grafana.json

curl -s -H "Content-Type: application/json" \
-XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
-d @./srcs/grafana/dashboards/influxdb.json

curl -s -H "Content-Type: application/json" \
-XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
-d @./srcs/grafana/dashboards/ingress.json

curl -s -H "Content-Type: application/json" \
-XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
-d @./srcs/grafana/dashboards/mysql.json

curl -s -H "Content-Type: application/json" \
-XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
-d @./srcs/grafana/dashboards/nginx.json

curl -s -H "Content-Type: application/json" \
-XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
-d @./srcs/grafana/dashboards/phpmyadmin.json

curl -s -H "Content-Type: application/json" \
-XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
-d @./srcs/grafana/dashboards/telegraf.json

curl -s -H "Content-Type: application/json" \
-XPOST http://MINIKUBE_IP:3000/api/dashboards/db \
-d @./srcs/grafana/dashboards/wordpress.json