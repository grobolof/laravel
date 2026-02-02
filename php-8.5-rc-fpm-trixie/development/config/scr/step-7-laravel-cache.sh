#!/bin/bash

alert_message "info" "Очистить/прогреть кэш"

php artisan cache:clear
php artisan view:clear
php artisan optimize
php artisan route:cache
php artisan config:clear
