docker run -d -p 10032:5432 -e DB_NAME=testdb -e DB_USER=tester -e PASSWORD=testerpass -e MAX_CONNECTIONS=200 philipsahli/postgresql-test 
