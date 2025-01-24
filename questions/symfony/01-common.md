# Распиши какие есть параметры у firewalls в symfony 7 и что они означают

Давайте подробно рассмотрим параметры firewalls, которые вы можете настроить в `config/packages/security.yaml`.

**Структура конфигурации firewalls:**

В `security.yaml` firewalls объявляются в секции `firewalls`, которая является массивом. Каждый элемент массива представляет собой отдельный firewall.

```yaml
security:
  # ...
  firewalls:
    main: # Имя firewall (может быть любым, но должно быть уникальным)
      # ... параметры firewall ...
    # другие firewall
  # ...
```

**Основные параметры firewall:**

1.  **`pattern` (обязательный):**

    *   **Тип:** строка (или массив строк)
    *   **Значение:** Регулярное выражение (или массив регулярных выражений) или путь (или массив путей)
    *   **Описание:**  Определяет, к каким URL-адресам будет применяться данный firewall. Если URL запроса соответствует шаблону, то данный firewall будет "активирован".  Регулярные выражения должны быть совместимыми с PCRE. Пути  являются упрощением для регулярных выражений, которые можно использовать для конкретных маршрутов.
        *   `^/api` - все URL начинающиеся с `/api`
        *   `^/admin` - все URL начинающиеся с `/admin`
        *   `^/login` - только `/login`
        *   `['^/api', '^/admin']` - URL начинающиеся с `/api` или `/admin`
        *   `/login`  - путь для `/login`
    *   **Примеры:**
        *   `pattern: ^/api`
        *   `pattern: ^/(login|register)`
        *   `pattern: ['/api/users', '/api/posts']`
        *   `pattern: /login`

2.  **`lazy` (необязательный):**

    *   **Тип:** `boolean`
    *   **Значение:** `true` или `false` (по умолчанию `false`)
    *   **Описание:** Если установлено в `true`, firewall будет инициализирован только тогда, когда он действительно необходим (например, когда пользователь пытается аутентифицироваться). Это может улучшить производительность для firewalls, которые не требуются на каждой странице.

3. **`provider` (необязательный, но часто используется):**

   *   **Тип:** строка
   *   **Значение:** Имя провайдера пользователей, определенного в секции `providers` (`security.yaml`).
   *   **Описание:** Указывает, откуда брать информацию о пользователях (например, из базы данных, файла или API). Если не указан,  аутентификация не будет выполнятся.
   *   **Примеры:**
        *   `provider: app_users` (если провайдер определен как `app_users` в `security.yaml`)

4.  **`entry_point` (необязательный):**

    *   **Тип:** строка
    *   **Значение:** Имя сервиса, реализующего интерфейс `Symfony\Component\Security\Http\EntryPoint\AuthenticationEntryPointInterface`.
    *   **Описание:** Указывает, что делать, если пользователь пытается получить доступ к защищенной ресурсу без аутентификации. Обычно используется для перенаправления на страницу входа или для возврата HTTP-ответа 401.  Если не установлен, то Symfony использует стандартный EntryPoint.
    *   **Примеры:**
        *  `entry_point: my_custom_entry_point` (если сервис `my_custom_entry_point` определен в `services.yaml`)

5. **`custom_authenticators` (необязательный):**

   *   **Тип:** массив строк
   *   **Значение:** Массив имен сервисов, реализующих интерфейс `Symfony\Component\Security\Http\Authenticator\AuthenticatorInterface`.
   *   **Описание:** Позволяет указать собственные аутентификаторы, которые будут использоваться для аутентификации пользователей. Порядок аутентификаторов важен, так как они будут вызываться по порядку, пока один из них не аутентифицирует пользователя.
   *   **Примеры:**
        *   `custom_authenticators: ['my_token_authenticator', 'my_form_authenticator']`

6.  **`logout` (необязательный):**

    *   **Тип:** массив
    *   **Описание:** Определяет параметры выхода пользователя из системы (logout).
        * **`path` (обязательный)**:  URL, по которому будет происходить logout.
        *   **`target` (необязательный)**: URL, на который пользователь будет перенаправлен после logout.
        *   **`invalidate_session` (необязательный)**:  Указывает, нужно ли инвалидировать сессию при выходе (по умолчанию `true`).
        *   **`delete_cookies` (необязательный)**:  Массив имен cookie, которые нужно удалить.
        *   **`success_handler` (необязательный)**: имя сервиса, который будет обрабатывать успешный logout.
        *   **`csrf_token_generator` (необязательный)**: имя сервиса, который генерирует csrf токен для logout.
    *  **Примеры:**
        ```yaml
        logout:
            path: /logout
            target: /
            invalidate_session: true
        logout:
           path: /api/logout
           success_handler: app.logout_success_handler
        ```

7.  **`remember_me` (необязательный):**

    *   **Тип:** массив
    *   **Описание:**  Конфигурирует функциональность "запомнить меня".
        *   **`secret` (обязательный)**:  Секрет, используемый для шифрования токена.
        *   **`lifetime` (необязательный)**: Срок действия токена (в секундах).
        *   **`path` (необязательный)**:  Путь для cookie с токеном.
        *   **`domain` (необязательный)**: Домен для cookie с токеном.
        *   **`secure` (необязательный)**:  Указывает, отправлять ли cookie только по HTTPS.
        *   **`httponly` (необязательный)**: Указывает, что cookie недоступен через JavaScript.
        *   **`samesite` (необязательный)**: Значение атрибута `SameSite` cookie.
    *   **Примеры:**
        ```yaml
        remember_me:
           secret: '%kernel.secret%'
           lifetime: 604800 # 7 days
           path: /
        ```

8.  **`access_denied_handler` (необязательный):**

    *   **Тип:** строка
    *   **Значение:** Имя сервиса, реализующего интерфейс `Symfony\Component\Security\Http\Authorization\AccessDeniedHandlerInterface`.
    *   **Описание:** Указывает, что делать, если пользователь попытался получить доступ к ресурсу, к которому у него нет прав. Обычно используется для перенаправления на страницу "доступ запрещен" или для возврата HTTP-ответа 403.
    *   **Примеры:**
        *   `access_denied_handler: my_custom_access_denied_handler`

9.  **`user_checker` (необязательный):**

    *   **Тип:** строка
    *   **Значение:**  Имя сервиса, реализующего интерфейс `Symfony\Component\Security\Core\User\UserCheckerInterface`.
    *   **Описание:**  Используется для проверки пользователя перед аутентификацией (например, для проверки, что пользователь не заблокирован).
    *   **Примеры:**
        *   `user_checker: app.user_checker`

10. **`form_login` (необязательный, но часто используется):**

    *   **Тип:** массив
    *   **Описание:**  Конфигурирует аутентификацию через форму входа.
        *   **`login_path` (обязательный)**:  URL страницы входа.
        *   **`check_path` (обязательный)**:  URL, куда отправляется форма с данными для аутентификации.
        *   **`username_parameter` (необязательный)**: Имя параметра, содержащего имя пользователя (по умолчанию `_username`).
        *   **`password_parameter` (необязательный)**: Имя параметра, содержащего пароль (по умолчанию `_password`).
        *  **`csrf_parameter` (необязательный)**: Имя параметра, содержащего CSRF токен.
        *  **`enable_csrf` (необязательный)**: Включать ли CSRF защиту, по умолчанию `true`.
        *   **`default_target_path` (необязательный)**: URL, куда перенаправлять пользователя после успешной аутентификации.
        *   **`always_use_default_target_path` (необязательный)**:  Всегда перенаправлять на `default_target_path` после аутентификации.
        *   **`failure_path` (необязательный)**:  URL для перенаправления в случае неудачи аутентификации.
        *    **`success_handler` (необязательный)**: Имя сервиса, который будет обрабатывать успешную аутентификацию.
        *   **`failure_handler` (необязательный)**: Имя сервиса, который будет обрабатывать неудачную аутентификацию.
    *   **Примеры:**

         ```yaml
        form_login:
             login_path: /login
             check_path: /login_check
             default_target_path: /dashboard
         ```
11. **`http_basic` (необязательный):**

     *  **Тип:** `array`
     *  **Описание:** Конфигурирует аутентификацию через HTTP Basic Authentication
          *  **`realm` (необязательный)**:  Отображаемое сообщение в диалоговом окне Basic Authentication

     *  **Примеры:**
         ```yaml
            http_basic:
                realm: "My Secured Area"
        ```

12.  **`stateless` (необязательный):**

   *   **Тип:** `boolean`
   *   **Значение:** `true` или `false` (по умолчанию `false`)
   *   **Описание:**  Если установлено в `true`, firewall не будет использовать сессии для хранения информации о пользователе. Это подходит для API, где аутентификация происходит через токены.

13. **`json_login` (необязательный):**

    *   **Тип:** массив
    *   **Описание:** Конфигурирует аутентификацию через JSON-запрос.
        *   **`check_path` (обязательный)**: URL, куда отправляется JSON-запрос.
        *   **`username_path` (необязательный)**:  Путь JSON к имени пользователя (по умолчанию `username`).
        *   **`password_path` (необязательный)**: Путь JSON к паролю (по умолчанию `password`).
        *  **`success_handler` (необязательный)**: Имя сервиса, который будет обрабатывать успешную аутентификацию.
        *   **`failure_handler` (необязательный)**: Имя сервиса, который будет обрабатывать неудачную аутентификацию.
    *   **Примеры:**
         ```yaml
         json_login:
              check_path: /api/login
              username_path: email
              password_path: pass
        ```

**Пример полной конфигурации `security.yaml`:**

```yaml
security:
  enable_authenticator_manager: true
  providers:
    app_users:
      entity:
        class: App\Entity\User
        property: email

  firewalls:
    dev:
      pattern: ^/(_(profiler|wdt)|css|images|js)/
      security: false
    main:
      pattern: ^/
      lazy: true
      provider: app_users
      form_login:
        login_path: /login
        check_path: /login_check
        default_target_path: /dashboard
      logout:
        path: /logout
        target: /
      remember_me:
        secret: '%kernel.secret%'
        lifetime: 604800
      access_denied_handler: app.access_denied_handler
    api:
      pattern: ^/api
      stateless: true
      custom_authenticators:
          - app.jwt_authenticator # Если вы используете JWT
      json_login:
        check_path: /api/login
        username_path: email
        password_path: pass
```

**Важные замечания:**

*   **Порядок firewalls:** Symfony обрабатывает firewalls в порядке их объявления.  Первый firewall, чей `pattern` соответствует запросу,  будет использоваться, остальные будут игнорированы.
*   **`security: false`:** Если вы установите `security: false`, то данный firewall не будет проверять аутентификацию и авторизацию для URL, которые соответствуют его `pattern`. Это может быть полезно для статических ресурсов или публичных страниц.
*   **Кастомные сервисы:** Многие параметры, такие как `entry_point`, `access_denied_handler`,  `success_handler`, и `failure_handler`, ссылаются на сервисы, которые вы должны определить в `services.yaml`.
*   **Аутентификаторы:** Вы можете использовать стандартные аутентификаторы (`form_login`, `http_basic`, `json_login`) или создавать собственные (`custom_authenticators`).

# Что означают папрамтеры Firewalls в security.yaml в Symfony 7?

## Базовые параметры

```yaml
security:
  firewalls:
    main:
      pattern: ^/         # Паттерн URL для которого применяется файрвол
      lazy: true         # Отложенная инициализация файрвола
      stateless: false   # Управление сессиями (true - без сессий)
      provider: app_user_provider  # Провайдер пользователей
```

## Методы аутентификации

### Form Login
```yaml
form_login:
  login_path: app_login     # Путь к странице логина
  check_path: app_login     # Путь обработки формы логина
  username_parameter: email # Имя поля для username
  password_parameter: password # Имя поля для пароля
  enable_csrf: true        # Защита от CSRF
```

### HTTP Basic
```yaml
http_basic:
  realm: Secured Area    # Область безопасности
```

### JSON Login
```yaml
json_login:
  check_path: app_login_json    # Путь для JSON аутентификации
  username_path: email          # Путь к username в JSON
  password_path: password       # Путь к паролю в JSON
```

### JWT Token
```yaml
jwt: ~    # Аутентификация через JWT токены
```

## Дополнительные параметры

### Logout
```yaml
logout:
  path: app_logout           # Путь для логаута
  target: app_home          # Редирект после логаута
  invalidate_session: true  # Инвалидация сессии
```

### Remember Me
```yaml
remember_me:
  secret: '%kernel.secret%'   # Секретный ключ
  lifetime: 604800           # Время жизни (в секундах)
  path: /                    # Путь для cookie
  secure: true              # Только HTTPS
```

### Access Control
```yaml
access_control:
  - roles: ROLE_USER
    path: ^/profile
    requires_channel: https
```

### Custom Authenticator
```yaml
custom_authenticators:
  - App\Security\CustomAuthenticator
```

## Важные параметры безопасности

```yaml
security_context:
  allow_if: "is_fully_authenticated()"  # Условие доступа
  requires_channel: https              # Требуемый протокол
  switch_user: true                    # Возможность смены пользователя
```

# Полное руководство по Firewalls в Symfony 7

## Базовые параметры
```yaml
security:
  firewalls:
    dev:                                # Файрвол для разработки
      pattern: ^/(_(profiler|wdt)|css|images|js)/ # URL паттерн для dev tools
      security: false                   # Отключение проверки безопасности
    
    main:                              # Основной файрвол
      lazy: true                       # Отложенная загрузка для оптимизации
      provider: app_user_provider      # Источник данных пользователей
      pattern: ^/                      # Применяется ко всем URL
      stateless: false                 # Использование сессий включено
```

## Методы аутентификации

### Form Login
```yaml
form_login:
  login_path: app_login                # URL страницы входа
  check_path: app_login_check          # URL проверки формы входа
  username_parameter: email            # Имя поля для идентификатора
  password_parameter: password         # Имя поля для пароля
  enable_csrf: true                    # Защита от CSRF-атак
  csrf_parameter: _csrf_token          # Имя CSRF токена
  default_target_path: app_homepage    # Редирект после успешного входа
  use_referer: true                    # Возврат на предыдущую страницу
  failure_path: app_login_failure      # URL при ошибке входа
  failure_handler: App\Security\AuthenticationFailureHandler  # Обработчик ошибок
  success_handler: App\Security\AuthenticationSuccessHandler  # Обработчик успеха
```

### JWT Authentication
```yaml
jwt:
  decoder: lexik_jwt_authentication.jwt_decoder    # Декодер JWT токенов
  encoder: lexik_jwt_authentication.jwt_encoder    # Энкодер JWT токенов
  token_extractors:                                # Методы извлечения токена
    - header:
        name: Authorization                        # Из заголовка
        prefix: Bearer                            # Префикс токена
    - query_parameter:                            # Из GET параметра
        name: token
    - cookie:                                     # Из cookie
        name: BEARER
```

### Социальные сети
```yaml
social_auth:
  google:
    client_id: '%env(GOOGLE_CLIENT_ID)%'          # ID приложения Google
    client_secret: '%env(GOOGLE_CLIENT_SECRET)%'  # Секрет приложения
    redirect_route: connect_google_check          # Маршрут обработки ответа
    scope: ['email', 'profile']                   # Запрашиваемые разрешения

  facebook:
    client_id: '%env(FACEBOOK_CLIENT_ID)%'
    client_secret: '%env(FACEBOOK_CLIENT_SECRET)%'
    redirect_route: connect_facebook_check
    graph_api_version: 'v12.0'                    # Версия API Facebook
```

## Управление сессиями
```yaml
session_management:
  session_fixation_strategy: migrate    # Стратегия защиты от фиксации сессии
  invalidate_session: true             # Удаление сессии при выходе
  session_cookie:
    name: SESSIONID                    # Имя cookie сессии
    lifetime: 3600                     # Время жизни в секундах
    secure: true                       # Только HTTPS
    httponly: true                     # Недоступно для JavaScript
    samesite: lax                      # Защита от CSRF
```

## Ограничение запросов
```yaml
rate_limiter:
  login:
    policy: token_bucket               # Алгоритм ограничения
    limit: 5                          # Максимальное количество попыток
    rate: { interval: '15 minutes' }  # Интервал сброса
    
  api:
    policy: sliding_window            # Скользящее окно
    limit: 100                       # Лимит запросов
    interval: '60 minutes'           # Период измерения
```

## Контроль доступа
```yaml
access_control:
  - path: ^/admin                     # URL админ панели
    roles: ROLE_ADMIN                 # Требуемая роль
    requires_channel: https           # Обязательный HTTPS
    
  - path: ^/api                       # URL API
    roles: ROLE_API_USER             # Роль для API
    methods: [POST, PUT, DELETE]      # Разрешенные методы
    ips: [127.0.0.1, ::1]           # Разрешенные IP
```

## Двухфакторная аутентификация
```yaml
two_factor:
  auth_form_path: 2fa_login           # Форма 2FA
  check_path: 2fa_check              # Проверка 2FA кода
  trusted_device_enabled: true       # Доверенные устройства
  trusted_device_lifetime: 2592000   # 30 дней доверия
  backup_codes_enabled: true         # Резервные коды
```

## Защитные заголовки
```yaml
security_headers:
  x_frame_options: SAMEORIGIN         # Защита от clickjacking
  x_content_type_options: nosniff     # Защита от MIME-сниффинга
  x_xss_protection: '1; mode=block'   # Защита от XSS
  content_security_policy:            # CSP настройки
    default-src: "'self'"
    script-src: "'self' 'unsafe-inline'"
```

## Провайдеры пользователей
```yaml
providers:
  app_user_provider:                  # Основной провайдер
    entity:
      class: App\Entity\User
      property: email
      
  api_user_provider:                  # API провайдер
    memory:
      users:
        api_user: { password: '%env(API_USER_PASSWORD)%', roles: ['ROLE_API'] }
        
  chain_provider:                     # Цепочка провайдеров
    chain:
      providers: ['app_user_provider', 'api_user_provider']
```

## Отладка
```yaml
debug:
  dump_authenticator_manager: true    # Вывод информации об аутентификации
  dump_firewall_events: true         # Логирование событий файрвола
  log_level: debug                   # Уровень логирования
```

## CORS для API
```yaml
cors:
  allow_origin: ['http://localhost:3000']  # Разрешенные источники
  allow_methods: ['GET', 'POST', 'PUT']    # Разрешенные методы
  allow_headers: ['Content-Type']          # Разрешенные заголовки
  max_age: 3600                           # Время кэширования
```

## Интеграция с компонентами
```yaml
security:
  firewalls:
    main:
      login_throttling:
        messenger: security.login_throttling.message  # Интеграция с Messenger
      remember_me:
        cache_pool: cache.security                   # Интеграция с Cache
```