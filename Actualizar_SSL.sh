#! /bin/bash

# Obtener los certificados
docker pull registry.gitlab.com/rodrigo.castillo.c/p-tis-tool-front
docker run --name ptis-front -p 80:80 registry.gitlab.com/rodrigo.castillo.c/p-tis-tool-front
docker exec -it ptis-front bash -c "chmod 775 Crear_SSL.sh && ./Crear_SSL.sh"
docker cp ptis-front:/certificates/cert_file.cer config/cert/cert_file.cer
docker cp ptis-front:/certificates/key_file.key config/cert/key_file.key
echo .................................
echo Se ha obtenido el certificado SSL
echo .................................

# Retirar aplicación actual
docker stop ptis-tool-api
docker rm ptis-tool-api
docker rmi ptis-back_api:latest
echo ....................................
echo Se ha eliminado la aplicación actual
echo ....................................

# Levantar aplicación en SSL
cp docker-compose.yml docker-compose.bak
cp docker-compose_SSL.yml docker-compose.yml
docker-compose up -d
echo ............................................
echo Se han creado las imagenes de la aplicación
echo ............................................

# Creación de la base de datos y carga de datos iniciales:
docker exec -it ptis-tool-api bundle exec rails db:migrate db:seed RAILS_ENV=production
echo ............................
echo ¡Base de datos actualizada!
echo ............................

# Borrar aplicación frontend
docker stop ptis-front
docker rm ptis-front
docker rmi registry.gitlab.com/rodrigo.castillo.c/p-tis-tool-front
echo ..............................
echo Eliminada aplicación frontend
echo ..............................
