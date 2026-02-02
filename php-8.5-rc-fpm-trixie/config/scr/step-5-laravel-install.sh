#!/bin/bash

alert_message "warning" "Проверка на то что Laravel установлен"

if [ ! -d $APP_PATH/public/ ]
then
  alert_message "info" "Установка Laravel"

  # Установить Laravel
  composer global require laravel/installer

  composer create-project laravel/laravel $APP_PATH --no-interaction && cd $APP_PATH

  # Установить пакеты
  composer require \
  php-ds/php-ds

  # Установить полные права на все папки и файлы
  chmod -R 777 .
fi

alert_message "success" "Laravel успешно установлен"
