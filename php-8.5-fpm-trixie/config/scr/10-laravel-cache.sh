#!/bin/bash
# Сбрасывает кэш Laravel (config, route, view, application).
# Чтобы подтянуть свежие настройки из .env после правок окружения.

if [[ ! -f "$APP_PATH/artisan" ]]; then
  log warning "artisan не найден — очистку кэша пропускаю"
else
  log info "Очищаю кэш Laravel…"
  php artisan optimize:clear --no-interaction
  log success "Кэш Laravel очищен"
fi
