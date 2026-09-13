#!/bin/bash
# Создаёт проект Laravel в APP_PATH, если artisan ещё нет.
# APP_PATH — корень репозитория (volume ./:${APP_PATH}), поэтому docker-compose.yml,
# makefile, README, .env и .gitignore не перезаписываются.

set_env() {
  local key=$1 value=$2 file="$APP_PATH/.env"
  [[ -f "$file" ]] || return 0
  if grep -qE "^#?${key}=" "$file"; then
    sed -i "s|^#\?${key}=.*|${key}=${value}|" "$file"
  else
    printf '%s=%s\n' "$key" "$value" >> "$file"
  fi
}

merge_env() {
  local src=$1 dest=$2
  [[ -f "$src" && -f "$dest" ]] || return 0
  local line key
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// }" ]] && continue
    key="${line%%=*}"
    [[ -n "$key" ]] || continue
    if ! grep -qE "^#?${key}=" "$dest"; then
      printf '%s\n' "$line" >> "$dest"
    fi
  done < "$src"
}

if [[ -f "$APP_PATH/artisan" ]]; then
  log success "Laravel уже есть в $APP_PATH — создавать не нужно"
else
  log info "Создаю проект Laravel 8 (последняя ветка с PHP 7.4), это может занять несколько минут…"
  composer create-project laravel/laravel:^8.0 /tmp/laravel-app --no-interaction

  # -n: не затираем файлы репозитория, уже лежащие в корне (compose, .env, README)
  cp -an /tmp/laravel-app/. "$APP_PATH/"

  if [[ ! -f "$APP_PATH/.env" ]]; then
    if [[ -f /tmp/laravel-app/.env ]]; then
      cp /tmp/laravel-app/.env "$APP_PATH/.env"
    elif [[ -f "$APP_PATH/.env.example" ]]; then
      cp "$APP_PATH/.env.example" "$APP_PATH/.env"
    fi
  fi

  merge_env /tmp/laravel-app/.env "$APP_PATH/.env"
  rm -rf /tmp/laravel-app

  set_env APP_URL "http://${APP_HOST}"
  set_env DB_CONNECTION "$DB_CONNECTION"
  set_env DB_HOST "$DB_HOST"
  set_env DB_PORT "$DB_PORT"
  set_env DB_DATABASE "$DB_DATABASE"
  set_env DB_USERNAME "$DB_USERNAME"
  set_env DB_PASSWORD "$DB_PASSWORD"

  if [[ -f "$APP_PATH/.env" ]] && ! grep -qE '^APP_KEY=.+' "$APP_PATH/.env"; then
    php artisan key:generate --force --no-interaction
  fi

  chmod -R ug+rwx "$APP_PATH/storage" "$APP_PATH/bootstrap/cache"
  log success "Проект Laravel создан в $APP_PATH"
fi
