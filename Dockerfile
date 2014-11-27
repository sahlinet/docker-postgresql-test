FROM bl-ubuntu:trusty

RUN apt-get update 
#RUN apt-get upgrade -y

RUN apt-get update 
RUN apt-get install -y postgresql-9.3 apg

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf
RUN echo "local   all             all                                     md5" >> /etc/postgresql/9.3/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

ADD postgresql.conf /etc/supervisor/conf.d/
ADD startup_postgres.sh /

EXPOSE 5432
