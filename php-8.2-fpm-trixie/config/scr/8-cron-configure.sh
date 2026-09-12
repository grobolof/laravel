#!/bin/bash
# Вешает поминутный запуск artisan schedule:run, если LARAVEL_CRON_ENABLED=1.
# Без крона планировщик Laravel (очередь по расписанию, рассылки) в контейнере не выполняется.

if [[ $LARAVEL_CRON_ENABLED != 1 ]]; then
  log warning "Крон выключен — планировщик Laravel запускаться не будет"
else
  log info "Включаю планировщик Laravel: artisan schedule:run каждую минуту…"
  { env; echo "*/1 * * * * cd ${APP_PATH} && /usr/local/bin/php artisan schedule:run >> /dev/null 2>&1"; } | crontab -
  log success "Крон настроен"
fi
