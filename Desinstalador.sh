#! /bin/bash

# Eliminación de contenedores:
docker-compose down
echo Contendores inhabilitados...

# Eliminación de las imagenes de la aplicación:
docker rmi ptistoolback_api postgres:10.14 ruby:2.6.6
echo ¡Se eliminaron las imágenes correctamente!
