#docker build -t postgresql-test --force-rm=true --rm=true --no-cache=true .
docker build -t postgresql-test --force-rm=true --rm=true .
docker tag postgresql-test philipsahli/postgresql-test
