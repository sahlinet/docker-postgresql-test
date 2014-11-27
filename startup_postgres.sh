echo "Setup Postgresql"
su postgres -c "/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf" &

echo "Create utf-8 template"
su postgres -c "echo \"CREATE DATABASE template2 WITH owner=postgres template=template0 encoding='UTF8'\"|psql"

if [ -z "$PGPASSWORD" ]; then
    echo "Generated postgres password:"
    PASS=`apg -n 1`
    echo "    $PASS"
else
    echo "Use postgres password from variable \$PGPASSWORD"
    PASS=$PGPASSWORD
fi
echo "Set postgres password"
su postgres -c "echo \"ALTER USER postgres WITH PASSWORD '$PASS'\"|psql"

echo "Create role $DB_USER"
su postgres -c "echo \"CREATE ROLE $DB_USER WITH PASSWORD '$PASSWORD'\"|psql"

echo "Create database $DB_NAME"
su postgres -c "echo \"CREATE DATABASE $DB_NAME WITH OWNER $DB_USER TEMPLATE template2\"|psql"
su postgres -c "echo \"ALTER ROLE $DB_USER WITH LOGIN\"|psql"
su postgres -c "echo \"GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER\"|psql"

pkill postgres
