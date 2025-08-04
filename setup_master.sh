#!/bin/bash

# Установка параметров
MYSQL_CNF="/etc/mysql/my.cnf"  # или /etc/mysql/mysql.conf.d/mysqld.cnf
REPLICA_USER="replica"
REPLICA_PASSWORD="password"
DB_NAME="sakila"

# Внесение изменений в конфигурацию
sudo bash -c "cat > $MYSQL_CNF" <<EOL
[mysqld]
server-id=1
log-bin=mysql-bin
binlog_do_db=$DB_NAME
EOL

# Перезапуск MySQL
sudo systemctl restart mysql

# Создание репликационного пользователя и получение master status
mysql -e "CREATE USER '$REPLICA_USER'@'%' IDENTIFIED BY '$REPLICA_PASSWORD';"
mysql -e "GRANT REPLICATION SLAVE ON *.* TO '$REPLICA_USER'@'%';"
mysql -e "FLUSH PRIVILEGES;"
mysql -e "FLUSH TABLES WITH READ LOCK;"
MASTER_STATUS=$(mysql -e "SHOW MASTER STATUS\G" | grep -E 'File|Position')

echo "$MASTER_STATUS"