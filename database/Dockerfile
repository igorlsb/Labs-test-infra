FROM postgres:latest

ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=adminpass
ENV POSTGRES_DB=mydb

# Copia o script SQL para dentro do container
COPY init.sql /docker-entrypoint-initdb.d/
