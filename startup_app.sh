#!/bin/bash
echo "Setup Postgresql"

# fix permission issue (https://github.com/docker/docker/issues/783)
#apt-get install ssl-cert -y
#rm -rf /etc/ssl/private
#mkdir /etc/ssl/private
#/usr/sbin/make-ssl-cert generate-default-snakeoil --force-overwrite

DIR="/var/lib/postgresql/9.3/main"

if [ ! -d "$DIR" ]; then
  mkdir -p $DIR
fi

[ "$(ls -A /var/lib/postgresql/9.3/main )" ] && echo "Data-dir has data" || (echo "Running initdb"; /usr/lib/postgresql/9.3/bin/initdb -D /var/lib/postgresql/9.3/main/)

/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf &

sleep 5

echo "Create utf-8 template"
echo "CREATE DATABASE template2 WITH owner=postgres template=template0 encoding='UTF8'"|psql

if [ -z "$PGPASSWORD" ]; then
    echo "Generated postgres password:"
    PASS=`apg -n 1`
    echo "    $PASS"
else
    echo "Use postgres password from variable \$PGPASSWORD"
    PASS=$PGPASSWORD
fi
echo "Set postgres password"
echo "ALTER USER postgres WITH PASSWORD '$PASS'"|psql

echo "Create role $DB_USER"
echo "CREATE ROLE $DB_USER WITH PASSWORD '$PASSWORD'"|psql

echo "Create database $DB_NAME"
echo "CREATE DATABASE $DB_NAME WITH OWNER $DB_USER TEMPLATE template2"|psql
echo "ALTER ROLE $DB_USER WITH LOGIN"|psql
if [ "$SUPERUSER" = "true" ]; then
    echo "set role to superuser"
    echo "ALTER ROLE $DB_USER WITH SUPERUSER"|psql
fi
echo "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER"|psql

pkill postgres

sleep 2

if [ -n "$MAX_CONNECTIONS" ]; then
    echo "set max_connections to $MAX_CONNECTIONS"
    sed -i "s/max_connections = .*/max_connections = ${MAX_CONNECTIONS}/" /etc/postgresql/9.3/main/postgresql.conf
    sed -i "s/log_min_duration_statement = .*/log_min_duration_statement = 250" /etc/postgresql/9.3/main/postgresql.conf
    sed -i "s/log_min_messages = .*/log_min_messages = INFO" /etc/postgresql/9.3/main/postgresql.conf
fi

sleep 3

while true; do date; psql -x -c "select * from pg_stat_database where datname ='$DB_NAME';"; sleep 120; done &

exec /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf
