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

## Примечания

1. `pattern` - определяет, к каким URL применяется файрвол
2. `lazy` - оптимизирует производительность
3. `stateless` - важен для API
4. `provider` - связывает с источником данных пользователей
5. `enable_csrf` - защита от CSRF атак
