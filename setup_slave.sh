#!/bin/bash

# Установка параметров
MASTER_IP="IP_МАСТЕР_СЕРВЕРА"
REPLICA_USER="replica"
REPLICA_PASSWORD="password"
MASTER_LOG_FILE="взято из мастер статуса"  # Например, mysql-bin.000001
MASTER_LOG_POS=номер_позиции  # Например, 107

# Внесение изменений в конфигурацию
MYSQL_CNF="/etc/mysql/my.cnf"  # или /etc/mysql/mysql.conf.d/mysqld.cnf
sudo bash -c "cat > $MYSQL_CNF" <<EOL
[mysqld]
server-id=2
relay-log=slave-relay-bin
log-bin=mysql-bin
read-only=1
EOL

# Перезапуск MySQL
sudo systemctl restart mysql

# Настройка slave
mysql -e "CHANGE MASTER TO 
MASTER_HOST='$MASTER_IP',
MASTER_USER='$REPLICA_USER',
MASTER_PASSWORD='$REPLICA_PASSWORD',
MASTER_LOG_FILE='$MASTER_LOG_FILE',
MASTER_LOG_POS=$MASTER_LOG_POS;"

mysql -e "START SLAVE;"