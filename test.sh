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
sleep 3
echo "SELECT 1 WHERE 1 = 0" | psql -h localhost -p 49432 -U test test 
sleep 3
rc=$?
docker stop $ID 2>/dev/null
docker rm $ID 2>/dev/null
exit $rc
