#!/bin/bash
# Создаёт проект Laravel, если artisan ещё нет в каталоге приложения.

set_env() {
  local key=$1 value=$2 file="$APP_PATH/.env"
  [[ -f "$file" ]] || return 0
  if grep -qE "^#?${key}=" "$file"; then
    sed -i "s|^#\?${key}=.*|${key}=${value}|" "$file"
  else
    printf '%s=%s\n' "$key" "$value" >> "$file"
  fi
}

if [[ -f "$APP_PATH/artisan" ]]; then
  log success "Laravel уже есть в $APP_PATH — создавать не нужно"
else
  log info "Создаю проект Laravel, это может занять несколько минут…"
  composer create-project laravel/laravel /tmp/laravel-app --no-interaction
  cp -a /tmp/laravel-app/. "$APP_PATH/"
  rm -rf /tmp/laravel-app

  set_env APP_URL "http://${APP_HOST}"
  set_env DB_CONNECTION "$DB_CONNECTION"
  set_env DB_HOST "$DB_HOST"
  set_env DB_PORT "$DB_PORT"
  set_env DB_DATABASE "$DB_DATABASE"
  set_env DB_USERNAME "$DB_USERNAME"
  set_env DB_PASSWORD "$DB_PASSWORD"

  chmod -R ug+rwx "$APP_PATH/storage" "$APP_PATH/bootstrap/cache"
  log success "Проект Laravel создан в $APP_PATH"
fi
