# Как залогировать в symfony получаемый запрос json до того как он распарситься

Чтобы залогировать JSON-запрос в Symfony до его парсинга, используйте слушатель событий на ранней стадии обработки запроса. Вот основные подходы:

### 1. Создание EventListener для kernel.request
Добавьте слушатель с высоким приоритетом, чтобы перехватить сырое тело запроса до обработки:

```php
// src/EventListener/RequestLoggerListener.php
use Psr\Log\LoggerInterface;
use Symfony\Component\HttpKernel\Event\RequestEvent;

class RequestLoggerListener
{
    public function __construct(
        private LoggerInterface $logger
    ) {}

    public function onKernelRequest(RequestEvent $event): void
    {
        $request = $event->getRequest();
        $content = $request->getContent();
        
        $this->logger->debug('Raw request body', [
            'content' => $content,
            'headers' => $request->headers->all()
        ]);
    }
}
```

Зарегистрируйте сервис с высоким приоритетом:
```yaml
# config/services.yaml
services:
    App\EventListener\RequestLoggerListener:
        tags:
            - { name: kernel.event_listener, event: kernel.request, priority: 1024 }
```

### 2. Использование middleware (для API Platform)
Для логирования в контексте API Platform можно создать кастомное middleware:

```php
// src/Middleware/RequestLoggerMiddleware.php
use Psr\Log\LoggerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\HttpKernelInterface;

class RequestLoggerMiddleware implements HttpKernelInterface
{
    public function __construct(
        private HttpKernelInterface $app,
        private LoggerInterface $logger
    ) {}

    public function handle(Request $request, $type = self::MAIN_REQUEST, $catch = true): Response
    {
        $this->logger->debug('API Request', [
            'body' => $request->getContent(),
            'method' => $request->getMethod(),
            'uri' => $request->getUri()
        ]);

        return $this->app->handle($request, $type, $catch);
    }
}
```

### 3. Настройка Monolog
Добавьте отдельный канал для логирования запросов в `config/packages/monolog.yaml`:

```yaml
monolog:
    channels: ['request']
    handlers:
        request:
            type: stream
            path: "%kernel.logs_dir%/request_%kernel.environment%.log"
            level: debug
            channels: ['request']
```

Используйте этот канал в вашем слушателе через инжектирование `LoggerInterface $requestLogger`.

### Важные замечания:
- Тело запроса доступно только один раз, используйте `$request->getContent()` до его парсинга[1][3]
- Для больших запросов ограничьте размер логируемых данных
- В production используйте обработчики типа `fingers_crossed` для уменьшения нагрузки[4]
- Убедитесь, что middleware/serveрислы имеют достаточный приоритет для раннего выполнения[6][7]

Пример вывода в лог:
```
[2024-01-31T12:00:00+00:00] DEBUG: Raw request body 
{"content":"{\"username\":\"test\",\"password\":\"secret\"}","headers":{"content-type":["application/json"],"accept":["*/*"]}}
```

Citations:
[1] https://stackoverflow.com/questions/46850247/how-to-handle-correctly-json-request-in-symfony/46892923
[2] https://symfonycasts.com/screencast/messenger/logger-channel
[3] https://stackoverflow.com/questions/60551681/api-platform-logging-headers-from-requests/60559417
[4] https://symfony.com/doc/current/logging.html
[5] https://symfonycasts.com/screencast/messenger/sent-received-logging
[6] https://stackoverflow.com/questions/43026349/log-every-request-symfony
[7] https://www.dataset.com/blog/getting-started-quickly-with-symfony-logging/
[8] https://symfonycasts.com/screencast/symfony-doctrine/request
[9] https://stackoverflow.com/questions/28444188/error-parsing-json-returned-via-symfony-components-jsonresponse/28456433
[10] https://symfony.com/doc/current/setup/symfony_server.html
[11] https://symfony.com/doc/current/http_client.html

---
Answer from Perplexity: pplx.ai/share