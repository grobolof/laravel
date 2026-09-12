#!/bin/bash
# Сбрасывает файловый кэш Laravel (config, route, view, events, compiled).
# cache:clear пропускаем: при CACHE_STORE=database нужна таблица cache,
# её создают миграции на следующем шаге.

if [[ ! -f "$APP_PATH/artisan" ]]; then
  log warning "artisan не найден — очистку кэша пропускаю"
else
  log info "Очищаю кэш Laravel…"
  if php artisan optimize:clear --except=cache --no-interaction; then
    log success "Кэш Laravel очищен"
  else
    log warning "Не удалось очистить кэш Laravel"
  fi
fi
