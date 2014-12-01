#!/bin/bash
docker stop postgresql-test-test 2>/dev/null
docker rm postgresql-test-test 2>/dev/null
ID=`docker run -d -p 49432:5432 -e DB_NAME=test -e DB_USER=test -e PASSWORD=test --name postgresql-test-test philipsahli/postgresql-test`
echo $ID
sleep 6
docker logs $ID
sleep 6
docker logs $ID
export PGPASSWORD=test
echo "SELECT 1 WHERE 1 = 0" | psql -h localhost -p 49432 -U test test 
rc=$?
docker stop $ID 2>/dev/null
docker rm $ID 2>/dev/null
exit $rc
