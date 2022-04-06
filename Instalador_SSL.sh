#! /bin/bash

# Obtener los certificados
docker pull registry.gitlab.com/rodrigo.castillo.c/p-tis-tool-front
docker run --name ptis-front -p 80:80 registry.gitlab.com/rodrigo.castillo.c/p-tis-tool-front
docker exec -it ptis-front bash -c "chmod 775 Crear_SSL.sh && ./Crear_SSL.sh"
docker cp ptis-front:/certificates/cert_file.cer config/cert/cert_file.cer
docker cp ptis-front:/certificates/key_file.key config/cert/key_file.key
echo Se ha obtenido el certificado SSL

# Levantar aplicación en SSL
cp docker-compose.yml docker-compose.bak
cp docker-compose_SSL.yml docker-compose.yml
docker-compose up -d
echo Se han creado las imagenes de la aplicación

# Creación de la base de datos y carga de datos iniciales:
docker exec -it ptis-tool-api bundle exec rails db:create db:migrate db:seed RAILS_ENV=production
echo ¡Base de datos iniciada!

# Borrar aplicación frontend
docker stop ptis-front
docker rm ptis-front
docker rmi registry.gitlab.com/rodrigo.castillo.c/p-tis-tool-front
