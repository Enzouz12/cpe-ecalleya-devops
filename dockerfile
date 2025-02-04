FROM postgres:14.1-alpine

COPY SQLFiles /docker-entrypoint-initdb.d