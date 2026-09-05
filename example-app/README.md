# Быстрый старт 🚀

- ⬇️ Скачайте [example-app](.) (переименуйте раздел под ваш проект).
- 📄 Скопируйте `.env.example` в `.env` (см. [таблицу с переменными](#env-vars)). В файле [docker-compose.yml](docker-compose.yml) представлены два контейнера `database`: postgres (рабочий) и mariadb (закомментирован). Можете ничего не менять — тогда СУБД будет PostgreSQL. Чтобы использовать MariaDB, закомментируйте postgres, раскомментируйте mariadb и в `.env` укажите `DB_CONNECTION=mysql`, `DB_PORT=3306`.
- ⚡ Запустите проект выполнив команду из корня проекта: `make up`.
- 📊 В логах контейнера `application` вам будет доступен процесс создания проекта.
- ✅ Завершением сборки можно считать появление строки `✅ КОНТЕЙНЕР ГОТОВ — ЗАПУСКАЮ NGINX И PHP-FPM`.

⚠️ **КОРЕНЬ ПРОЕКТА** означает файлы приложения в папке `app`, которые будут смонтированы в контейнер!

<a id="env-vars"></a>

| Название переменной | Описание переменной | Требуется |
| :------------------ | :------------------ | :-------- |
| <a id="APP_HOST"></a>[APP_HOST](#APP_HOST) | Хост вашего проекта (хост необходимо добавить в файл hosts вашей системы, пример: `127.0.0.1   laravel.docker.local`) | ✅ |
| <a id="APP_PATH"></a>[APP_PATH](#APP_PATH) | Путь от корня до проекта внутри контейнера | ✅ |
| <a id="DB_CONNECTION"></a>[DB_CONNECTION](#DB_CONNECTION) | Драйвер Eloquent: `pgsql` (по умолчанию), `mysql`, `mariadb`, `sqlite`. Любое другое значение — ошибка при старте контейнера | ❌ |
| <a id="DB_HOST"></a>[DB_HOST](#DB_HOST) | Хост базы данных (хостом БД является название контейнера СУБД из docker-compose.yml; используется для СУБД и Eloquent) | ✅ |
| <a id="DB_PORT"></a>[DB_PORT](#DB_PORT) | Порт базы данных. По умолчанию `5432` (PostgreSQL). Для MariaDB/MySQL укажите `3306` | ❌ |
| <a id="DB_DATABASE"></a>[DB_DATABASE](#DB_DATABASE) | Название базы данных (используется для СУБД и Eloquent) | ✅ |
| <a id="DB_USER"></a>[DB_USER](#DB_USER) | Имя пользователя для базы данных (используется для СУБД и Eloquent) | ✅ |
| <a id="DB_PASSWORD"></a>[DB_PASSWORD](#DB_PASSWORD) | Пароль пользователя для базы данных (используется для СУБД и Eloquent) | ✅ |
| <a id="DB_ROOT_PASSWORD"></a>[DB_ROOT_PASSWORD](#DB_ROOT_PASSWORD) | Секретный пароль пользователя root (нужен только если СУБД — MariaDB) | ❌ |
| <a id="LARAVEL_CRON_ENABLED"></a>[LARAVEL_CRON_ENABLED](#LARAVEL_CRON_ENABLED) | Вкл/выкл CRON (1 - вкл.; раз в минуту): `php artisan schedule:run`. Допустимы только `0` или `1` | ✅ |
| <a id="MAILPIT_ENABLED"></a>[MAILPIT_ENABLED](#MAILPIT_ENABLED) | Вкл/выкл mailpit (1 - вкл.). Если задана — только `0` или `1`; любое другое значение — ошибка при старте контейнера | ❌ |
| <a id="MAILPIT_HOST"></a>[MAILPIT_HOST](#MAILPIT_HOST) | Хост mailpit. Обязательна, если [`MAILPIT_ENABLED`](#MAILPIT_ENABLED)=1 | ❌ |

## Установка Laravel

После успешной сборки проекта можете перейти на страницу `http://APP_HOST` (заменить [**APP_HOST**](#APP_HOST) на хост из `.env` файла). Вы должны увидеть приветственную страницу `Laravel`.

1. Если в каталоге `app` ещё не было проекта, контейнер сам создаст актуальную версию Laravel через `composer create-project`.
2. При первом создании проекта в файл `app/.env` записываются [`APP_HOST`](#APP_HOST) (как `APP_URL`) и доступы к СУБД из переменных окружения.
3. Миграции Laravel накатываются автоматически после готовности базы.
4. Для перехода в панель нет отдельного URL: работайте через `php artisan` (см. [команды](#команды) и `make artisan`).
5. 🔥 **Laravel** успешно установлен!

# Дополнительные настройки 🛠️

Дополнительные настройки являются рекомендованными, но необязательными и не препятствуют успешной работе проекта.

## Доступы СУБД для Laravel через переменные окружения

👇 При первом создании проекта значения уже подставляются в `app/.env`. Если создаёте проект вручную, замените в `app/.env` переменные ([DB_CONNECTION](#DB_CONNECTION), [DB_HOST](#DB_HOST), [DB_PORT](#DB_PORT), [DB_DATABASE](#DB_DATABASE), [DB_USER](#DB_USER), [DB_PASSWORD](#DB_PASSWORD)).

```
DB_CONNECTION=pgsql
DB_HOST=database
DB_PORT=5432
DB_DATABASE=laravel
DB_USERNAME=login
DB_PASSWORD=pass
```

## Настройка почты через Mailpit

👇 Если [`MAILPIT_ENABLED`](#MAILPIT_ENABLED)=1, контейнер направит `mail()` PHP в Mailpit и пропишет SMTP в `app/.env`. Письма смотрите на `http://localhost:8025`.

# Документация, пакеты и команды 🎨

В данном пункте представлены полезные ссылки на документацию и пакеты для более комфортной разработки.

## Документация

1. [Routing](https://laravel.com/docs/routing) — Маршруты и REST API.
2. [Eloquent](https://laravel.com/docs/eloquent) — Работа с базой данных.
3. [Artisan](https://laravel.com/docs/artisan) — Консольные команды.

## Пакеты

### Тестирование и рефакторинг

1. [pint](https://github.com/laravel/pint) — Официальный форматтер Laravel (есть в проекте по умолчанию).
2. [rector](https://github.com/rectorphp/rector) — Автоматический рефакторинг PHP: обновляет синтаксис и упрощает конструкции. Пример [конфига](attachments/packages/rector/rector.php) (скопировать в корень проекта).
3. [php-cs-fixer](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer) — Форматирует код по PSR-12 и заданным правилам стиля. Пример [конфига](attachments/packages/php-cs-fixer/.php-cs-fixer.dist.php) (скопировать в корень проекта).
4. [phpstan](https://github.com/phpstan/phpstan) — Статический анализ: находит ошибки типов и логики без запуска кода. Пример [конфига](attachments/packages/phpstan/phpstan.neon) (скопировать в корень проекта).

### Lefthook (git)

**Lefthook** — это инструмент для управления Git-хуками.

- Установить [Node.js](https://nodejs.org/en/download)
- В корне проекта запустить команду, которая установит пакет `lefthook`

```bash
npm install lefthook --save-dev
```

- В корне проекта запустить команду, которая настроит `git hooks` из файла `lefthook.yml`

```bash
node_modules/.bin/lefthook install
```

- Залить изменения в ваш Git репозиторий
- Файл `lefthook.yml` изменить следующим образом (при каждом `git push` автоматически проверяет и рефакторит код):

```yaml
pre-commit:
  commands:
    # ПРИ УСЛОВИИ ЧТО УСТАНОВЛЕН PINT:
    pint:
      priority: 1
      run: make pint && git add {staged_files}

    # ПРИ УСЛОВИИ ЧТО УСТАНОВЛЕН ПАКЕТ PHPSTAN:
    phpstan:
      priority: 2
      run: make phpstan

    # ПРИ УСЛОВИИ ЧТО УСТАНОВЛЕН ПАКЕТ RECTOR:
    rector:
      priority: 3
      run: make rector && git add {staged_files}
```

## Команды

### Загрузить БД в контейнер (postgres)

```bash
docker exec -i $(basename $(pwd))-database-1 sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < ./docker/postgres/db.sql
```

### Выгрузить БД из контейнера (postgres)

```bash
docker exec $(basename $(pwd))-database-1 sh -c 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB"' > ./docker/postgres/db.sql
```

### Загрузить БД в контейнер (mariadb)

```bash
docker exec -i $(basename $(pwd))-database-1 sh -c 'mariadb -u root --password="$MARIADB_ROOT_PASSWORD" laravel' < ./docker/mariadb/db.sql
```

### Выгрузить БД из контейнера (mariadb)

```bash
docker exec $(basename $(pwd))-database-1 sh -c 'exec mariadb-dump --all-databases -uroot -p"$MARIADB_ROOT_PASSWORD"' > ./docker/mariadb/db.sql
```
