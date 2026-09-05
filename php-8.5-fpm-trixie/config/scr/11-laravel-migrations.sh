#!/bin/bash
# Накатывает миграции Laravel, когда доступны artisan и база.
# Если СУБД ещё не готова — шаг не роняет контейнер, только предупреждает.

if [[ ! -f "$APP_PATH/artisan" ]]; then
  log warning "artisan не найден — миграции пропускаю"
elif [[ $DB_CONNECTION == sqlite ]]; then
  log info "Накатываю миграции Laravel (sqlite)…"
  if php artisan migrate --force --no-interaction; then
    log success "Миграции выполнены"
  else
    log warning "Миграции не выполнены — проверьте подключение к БД"
  fi
else
  log info "Жду СУБД $DB_HOST:$DB_PORT и накатываю миграции…"
  if ! wait-for-it "${DB_HOST}:${DB_PORT}" -t 60; then
    log warning "СУБД не отвечает — миграции пропускаю"
  else
    migrated=0
    for _ in 1 2 3 4 5 6 7 8 9 10; do
      if php artisan migrate --force --no-interaction; then
        migrated=1
        break
      fi
      sleep 3
    done
    if [[ $migrated == 1 ]]; then
      log success "Миграции выполнены"
    else
      log warning "Миграции не выполнены — проверьте подключение к БД"
    fi
  fi
fi
