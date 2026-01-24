# Как в логи symfony 7 (monolog) добавить автоматическое добавление id request

Самый «симфоничный» способ — **Monolog Processor**, который на каждый LogRecord добавляет `request_id` в `extra`. Symfony это прямо рекомендует для “уникального токена запроса” и показывает пример с `LogRecord`/`ProcessorInterface` + `monolog.processor`/`#[AsMonologProcessor]`. ([symfony.com][1])

Ниже рабочий вариант для Symfony 7 + Monolog 3.

---

## 1) (Опционально) гарантируем, что request id вообще есть

Если `X-Request-Id` уже приходит от nginx/ingress/load balancer — этот шаг можно пропустить.

```php
<?php
// src/EventSubscriber/RequestIdSubscriber.php
namespace App\EventSubscriber;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\Event\ResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;
use Symfony\Component\Uid\Uuid;

final class RequestIdSubscriber implements EventSubscriberInterface
{
    private const HEADER = 'X-Request-Id';
    private const ATTR = '_request_id';

    public static function getSubscribedEvents(): array
    {
        return [
            KernelEvents::REQUEST => ['onKernelRequest', 100],
            KernelEvents::RESPONSE => ['onKernelResponse', -100],
        ];
    }

    public function onKernelRequest(RequestEvent $event): void
    {
        if (!$event->isMainRequest()) {
            return;
        }

        $request = $event->getRequest();

        $rid = $request->headers->get(self::HEADER);
        if (!$rid) {
            $rid = Uuid::v4()->toRfc4122();
            $request->headers->set(self::HEADER, $rid);
        }

        $request->attributes->set(self::ATTR, $rid);
    }

    public function onKernelResponse(ResponseEvent $event): void
    {
        if (!$event->isMainRequest()) {
            return;
        }

        $request = $event->getRequest();
        $rid = $request->headers->get(self::HEADER) ?? $request->attributes->get(self::ATTR);

        if ($rid && !$event->getResponse()->headers->has(self::HEADER)) {
            $event->getResponse()->headers->set(self::HEADER, $rid);
        }
    }
}
```

(Идея такая же, как в популярных реализациях: выставить/прокинуть `X-Request-Id` на request/response.) ([dylan-ballandras.fr][2])

---

## 2) Processor, который добавляет request id в каждый лог

```php
<?php
// src/Logger/RequestIdProcessor.php
namespace App\Logger;

use Monolog\Attribute\AsMonologProcessor;
use Monolog\LogRecord;
use Monolog\Processor\ProcessorInterface;
use Symfony\Component\HttpFoundation\RequestStack;

#[AsMonologProcessor] // можно: #[AsMonologProcessor(channel: 'app')] или handler: 'main'
final class RequestIdProcessor implements ProcessorInterface
{
    public function __construct(private RequestStack $requestStack) {}

    public function __invoke(LogRecord $record): LogRecord
    {
        $request = $this->requestStack->getCurrentRequest();
        if (!$request) {
            return $record; // например, CLI/воркеры без HTTP-запроса
        }

        $rid = $request->headers->get('X-Request-Id')
            ?? $request->attributes->get('_request_id');

        if ($rid) {
            $record->extra['request_id'] = $rid;
        }

        return $record;
    }
}
```

`#[AsMonologProcessor]` — официальный способ не писать тег руками; Symfony прямо это описывает. ([symfony.com][1])

Если не хотите атрибут — можно тегом в `services.yaml`:

```yaml
services:
  App\Logger\RequestIdProcessor:
    tags: [ 'monolog.processor' ]
```

([symfony.com][1])

---

## 3) Выводим request id в формате логов

Самый простой способ — кастомный formatter и вставить `%extra.request_id%`:

```yaml
# config/services.yaml
services:
  monolog.formatter.request_id:
    class: Monolog\Formatter\LineFormatter
    arguments:
      - "[%%datetime%%] [%%extra.request_id%%] %%channel%%.%%level_name%%: %%message%% %%context%% %%extra%%\n"
```

```yaml
# config/packages/monolog.yaml
monolog:
  handlers:
    main:
      type: stream
      path: "%kernel.logs_dir%/%kernel.environment%.log"
      level: debug
      formatter: monolog.formatter.request_id
```

Идея с formatter’ом и использованием `extra.*` — ровно из официального примера Symfony (там `extra.token`, у нас `extra.request_id`). ([symfony.com][1])

---

### Если есть Messenger/async

В HTTP-воркере `RequestStack` пустой, поэтому request id нужно **прокидывать в message envelope (Stamp) и доставать отдельным processor’ом** — хороший рабочий пример есть в статье (шаги про middleware+stamp+processor). ([dylan-ballandras.fr][2])

