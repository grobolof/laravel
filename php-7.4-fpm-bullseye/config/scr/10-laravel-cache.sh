#!/bin/bash
# Сбрасывает файловый кэш Laravel (config, route, view, compiled).
# cache:clear пропускаем: при database-кэше нужна таблица cache,
# её создают миграции на следующем шаге.
# Laravel 8 не поддерживает optimize:clear --except=cache (это Laravel 11+).

if [[ ! -f "$APP_PATH/artisan" ]]; then
  log warning "artisan не найден — очистку кэша пропускаю"
else
  log info "Очищаю кэш Laravel…"
  if php artisan config:clear --no-interaction \
    && php artisan route:clear --no-interaction \
    && php artisan view:clear --no-interaction \
    && php artisan clear-compiled --no-interaction; then
    log success "Кэш Laravel очищен"
  else
    log warning "Не удалось очистить кэш Laravel"
  fi
fi
