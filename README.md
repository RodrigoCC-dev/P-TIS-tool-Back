# API Backend de la Herramienta de apoyo a los cursos de Proyecto y Taller de Ingeniería de Software del Departamento de Ingeniería Informática de la USACH

## Entorno de desarrollor

* Ubuntu 18.04
* rvm 1.29.10
* nodejs 10.23.0
* yarn 1.22.5

## Requisitos

* ruby 2.6.6
* rails 6.0.3.3
* nodejs, yarn
* postgreSQL 10.14
* gemas pg, bundler

## Instalación
### RVM
RVM es una herramienta que permite tener multiples instalaciones de Ruby en el sistema. Para su instalación, se debe contar con cURL instalado:
```
sudo apt install curl
```
Instalar RVM haciendo uso de cURL:
```
\curl -sSL https://get.rvm.io | bash
```
Modificar el bash para que reconozca las instrucciones de RVM:
```
echo 'source "$HOME/.rvm/scripts/rvm"' >> ~/.bashrc
```
Cerrar sesión para que los cambios al bash se apliquen a partir de nuevas sesiones.
Abrir la terminal y completar la instalación solicitando las partes de RVM que faltan:
```
rvm requirements
```
### Ruby
Con RVM instalado, la instalación de Ruby en la versión necesaria se realiza con el siguiente comando:
```
rvm install ruby-2.6.6
```
Dejar la instalación de Ruby v2.6.6 como por defecto:
```
rvm --default use 2.6.6
```
### Rails
Una vez instalado Ruby, la instalación de Rails se realiza a través de la instalación de la gema 'rails':
```
gem install rails
```
Para comprobar la instalación y versión de Rails:
```
rails -v
```
### Node.js
Agregar repositorio de origen de la descarga:
```
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
```
Luego, instalar:
```
sudo apt install -y nodejs
sudo apt install gcc g++ make
```
### Yarn
```
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
```
### Postgres
Instalar postgres en el sistema:
```
sudo apt install postgresql postgresql-contrib libpq-dev
```
ingresar como usuario postgres
```
sudo su - postgres
psql
```
crear un rol para tu usuario actual, su base de datos por defecto y su password de acceso:
```
create role 'tu_usuario' with createdb login password 'tu_password';
```
salir de la consola
```
\q
```
### Instalar gema bundler
```
gem update --system
gem install bundler
```
### Clonar, instalar dependencias y desplegar
Clonar repositorio e ingresar a su directorio:
```
git clone https://github.com/RodrigoCC-dev/P-TIS-tool-Back.git ptis-back
cd ptis-back
```
Generar archivo de variables de entorno para la aplicación copiando archivo .env.example a .env y editarlo:
```
cp .env.example .env
nano .env
```
cambiar valores de variables de entorno, ejemplo:
```
DB_USERNAME='tu_usuario_BD'
DB_PASSWORD='tu_password_BD'
DB_HOST='el_host_de_tu_BD' # ejemplo: localhost
CORS_ORIGINS='' # Origenes permitidos para el uso de la API separados por coma, ejemplo: *
```
Instalar las dependencias:
```
bundle install
```
Generar la base de datos:
```
rails db:create db:migrate db:seed
```
Desplegar la aplicación en entorno de desarrollo:
```
rails server
```

## Testeo
Para ejecutar las pruebas automatizadas de la aplicación, es necesario generar la base de datos de testeo con los siguientes comandos:
```
rails db:test:purge
rails db:prepare
```
Luego, ejecutar los test:
```
rails test
```

## Despliegue en producción
La siguiente descripción del despliegue de la aplicación se realiza para un servidor con Ubuntu 18.04. Para otras versiones de distribución pueden haber variaciones en los comandos indicados. Se considera que ya se encuentran instaladas las dependencias necesarias. Para su instalación, ver el apartado de Instalación.

### Instalación en producción con la configuración actual
Igresar al directorio de trabajo. Para ejemplificar se utiliza la carpeta /opt del sistema. Clonar el repositorio con permisos de superusuario:
```
cd /opt
sudo git clone https://github.com/RodrigoCC-dev/P-TIS-tool-Back.git ptis-back
```
Cambiar los permisos de acceso a la carpeta de la aplicación e ingresar al directorio de la aplicación:
```
sudo chown -R tu-usuario.tu-usuario ptis-back
sudo chmod -R 775 ptis-back
cd ptis-back
```
Crear el archivo de variables de entorno de la aplicación:
```
cp .env.example .env
nano .env
```
Cambiar valores por parámetros de producción:
```
DB_USERNAME='usuario_BD_produccion'
DB_PASSWORD='password_BD_produccion'
DB_HOST='host_BD_produccion'
CORS_ORIGINS='' # Origenes permitidos para el uso de la API separados por coma, ejemplo: *
```
Generar la clave secreta de Rails para el entorno de producción:
```
SECRET_ENV_VAR=$(bundle exec rails secret)
echo -e "production:\n  secret_key_base:" > ./config/.example_secrets.yml
echo "$(cat ./config/.example_secrets.yml) $SECRET_ENV_VAR" > ./config/secrets.yml
```
Instalar las dependencias de la aplicación en entorno de producción:
```
bundle install --deployment --without development test
```
Inicializar la base de datos en producción
```
bundle exec rails db:create db:migrate db:seed RAILS_ENV=production
```
Arrancar la aplicación en producción:
```
rvmsudo bundle exec passenger start
```
La aplicación se iniciará en el puerto 8080 del servidor.

### Cambiar la configuración de la ejecución de la aplicación en producción
La configuración de la ejecución de la aplicación en entorno de producción se encuentra definida en el archivo Passengerfile.json que se encuentra en el directorio raíz de la aplicación. La estructura del archivo de configuración de Passenger es la siguiente:
```
{
  "environment": "production",   // Se indica el entorno que se ejecutará
  "port": 8080,                  // Se indica el puerto de trabajo
  "daemonize": true,             // Se indica que debe correr en modo 'demonio'
  "user": "tu-usuario"           // Se indica el usuario que hará uso de la aplicación
}
```

### Actualizar la aplicación
Para actualizar la aplicación a su versión más reciente, ingresar a la carpeta raiz y ejecutar:
```
cd /opt/ptis-back
git pull
```
Instalar las nuevas dependencias de la aplicación
```
bundle install --deployment --without development test
```
Volver a compilar e instalar las nuevas migraciones
```
bundle exec rails db:migrate RAILS_ENV=production
```
Reiniciar la aplicación:
```
bundle exec passenger-config restart-app $(pwd)
```
