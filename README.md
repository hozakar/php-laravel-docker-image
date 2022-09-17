# Docker image for PHP 8.1 + Laravel 9

Alpine, NGINX, PHP8.1-fpm, Composer, Node.js, Laravel 9

docker-compose.yml example

```sh
version: "3.9"
services:
  app:
    image: hozakar/php-laravel
    container_name: myapp
    ports:
      - ${APP_PORT}:8080
    volumes:
      - ${APP_ROOT}:/project

  db:
    image: mysql
    restart: always
    ports:
      - ${MYSQL_PORT}:3306
    environment:
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USERNAME}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    volumes:
      # - /var/lib/mysql
      # if you want to mount mysql
      # to a specific directory on the host
      # use the one below
      - ${MYSQL_MOUNT:-./db_mount}:/var/lib/mysql
      
  adminer:
    image: adminer
    restart: always
    ports:
      - ${ADMINER_PORT}:8080
    depends_on:
      - db

  jobs:
    restart: unless-stopped
    image: hozakar/jobber-curl
    container_name: jobs
    volumes:
      - ${JOBBER_FILE}:/home/jobberuser/.jobs
    depends_on:
      - app
```

.env file example

```sh
APP_PORT: 80
APP_ROOT: ./project

MYSQL_ROOT_PASSWORD: super_secret_root_password
MYSQL_DATABASE: laravel
MYSQL_USERNAME: laravel
MYSQL_PASSWORD: secret
MYSQL_PORT: 33060
MYSQL_MOUNT: ./db

ADMINER_PORT: 3000

JOBBER_FILE: ./jobs/.jobs
```
