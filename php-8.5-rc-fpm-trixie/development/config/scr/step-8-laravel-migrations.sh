#!/bin/bash

alert_message "info" "Накатить миграции"

php artisan migrate
