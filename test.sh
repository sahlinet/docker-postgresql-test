docker stop postgresql-test-test 2>/dev/null
docker rm postgresql-test-test 2>/dev/null
ID=`docker run -d -p 55432:5432 -e DB_NAME=test -e DB_USER=test -e PASSWORD=test --name postgresql-test-test postgresql-test`
echo $ID
sleep 8
docker logs $ID
set PGPASSWORD=test
echo "select * from dual" | psql -h localhost -p 5432 -U test test 
rc=$?
docker stop $ID 2>/dev/null
docker rm $ID 2>/dev/null
exit $rc
