#! /bin/bash

# Creación de contenedores:
docker-compose up -d
echo Se han creado las imagenes de la aplicación

# Creación de base de datos y carga de datos iniciales:
docker exec -it ptis-tool-api bundle exec rails db:create db:migrate db:seed RAILS_ENV=production
echo ¡Base de datos iniciada!
