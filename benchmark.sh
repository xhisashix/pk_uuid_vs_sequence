#!/bin/bash

# Wait for MySQL to be ready
until mysqladmin ping -h mysql --silent; do
  echo "Waiting for MySQL to be ready..."
  sleep 2
done

# Create database and tables
mysql -h mysql -uroot -ppassword -e "CREATE DATABASE IF NOT EXISTS benchmarkdb;"
mysql -h mysql -uroot -ppassword -e "CREATE TABLE IF NOT EXISTS benchmarkdb.table_uuid (id VARCHAR(36) PRIMARY KEY, data VARCHAR(255));"
mysql -h mysql -uroot -ppassword -e "CREATE TABLE IF NOT EXISTS benchmarkdb.table_sequence (id INT AUTO_INCREMENT PRIMARY KEY, data VARCHAR(255));"

# INSERT performance
echo "## INSERT performance"
mysqlslap --host=mysql --user=root --password=password --concurrency=100 --iterations=10 --query="INSERT INTO benchmarkdb.table_uuid VALUES (UUID(), 'data')" --create-schema=benchmarkdb
mysqlslap --host=mysql --user=root --password=password --concurrency=100 --iterations=10 --query="INSERT INTO benchmarkdb.table_sequence VALUES (NULL, 'data')" --create-schema=benchmarkdb
