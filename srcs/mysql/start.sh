#!/bin/sh

  mysql_install_db --user=root > /dev/null

MYSQL_ROOT_PASSWORD=password
    
MYSQL_DATABASE=wordpress

mkdir -p /run/mysqld

  tfile=`mktemp`

  cat << EOF > $tfile
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
EOF
echo "[i] Creating database: $MYSQL_DATABASE"
echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
  
/usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
rm -f $tfile

exec /usr/bin/mysqld --user=root --console