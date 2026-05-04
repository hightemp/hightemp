# Livepatch

Источник: https://docs.kernel.org/livepatch/livepatch.html

Версия документации: 7.1.0-rc2

Дата обращения: 2026-05-04

## Ключевые идеи

- `Livepatch` в ядре Linux - это не просто "подменить функцию на лету", а безопасно перевести систему на новую реализацию без reboot и без поломки текущих execution paths.
- Базовый механизм редиректа строится поверх `dynamic ftrace`: именно он позволяет перехватывать вход в функцию и направлять вызов в новую реализацию. Поэтому livepatch тесно связан с `ftrace`, `kprobes` и ограничениями трассировки.
- Главная сложность не в загрузке нового кода, а в consistency model: когда именно конкретную задачу уже безопасно перевести на patched version, если она может держать locks, спать внутри старой функции или жить в kernel space дольше обычного.
- Текущая модель livepatch гибридная: она сочетает per-task consistency и syscall barrier switching из `kGraft` со stack trace switching из `kpatch`.
- Переключение происходит не мгновенно для всей системы, а через `transition state`: задачи постепенно сходятся к patched или unpatched state, и только после этого patch считается завершённым.
- Для sleeping tasks лучший сценарий - stack checking: если затронутых функций нет в stack trace, задачу можно переключать. Поэтому качество и надёжность `reliable stacktrace` напрямую влияют на то, насколько полноценно архитектура поддерживает livepatch.
- Для user tasks, которые не удаётся быстро перевести через stack checking, ядро использует kernel exit switching: задача меняет состояние при выходе в user space после system call, signal или IRQ.
- Idle tasks переключаются через явный вызов `klp_update_patch_state()` в idle loop. С `kthreads` всё сложнее: без надёжного stack tracing или специально выбранных safe patch points поддержка получается слабее.
- Livepatch распространяется как kernel module, который содержит новые версии функций и metadata-структуры `struct klp_func`, `struct klp_object` и `struct klp_patch`, описывающие, что именно заменяется и в каком объекте.
- Документация явно подталкивает к cumulative patches: они лучше сохраняют целостность изменений, чем длинная цепочка независимых live patches.

## Практические интерфейсы

- `/sys/kernel/livepatch/<patch>/enabled` - включает и выключает patch.
- `/sys/kernel/livepatch/<patch>/transition` - показывает, находится ли patch в фазе convergence.
- `/sys/kernel/livepatch/<patch>/force` - аварийный способ принудительно завершить transition, но после него удаление patch module отключается и стоит планировать reboot.
- `/proc/<pid>/patch_state` - помогает понять, какие задачи блокируют завершение transition.

## Ограничения

- Патчить можно только функции, которые совместимы с `dynamic ftrace`.
- Надёжная работа ожидает, что hook `ftrace` стоит в самом начале функции; на `x86_64` это завязано на `-fentry`.
- `kretprobes` на базе `ftrace` конфликтуют с patched functions, потому что обе техники хотят управлять return address.
- `Kprobes` в оригинальной функции после редиректа в новую реализацию фактически перестают наблюдать исполняемый путь.
- Архитектуры без `HAVE_RELIABLE_STACKTRACE` считаются неполноценной средой для livepatch, потому что для них хуже решается безопасное переключение задач и особенно `kthreads`.

## Что забрать в permanent notes

- Runtime patching в kernel - это прежде всего задача безопасного перехода между semantic states, а не только задача редиректа execution flow.
- Per-task convergence часто практичнее и безопаснее глобального мгновенного переключения всей системы.
- Наблюдаемость перехода через `sysfs` и `procfs` - важная часть operational design, а не второстепенная обвязка.
- Если механизм hot patching требует `force`, он уже вышел из штатного сценария и должен вести к планированию reboot, а не к бесконечной цепочке следующих live patches.

## Цитаты

- `consistency model`
- `transition state`
- `HAVE_RELIABLE_STACKTRACE`
- `cumulative livepatches`

## Связи

- [Словарь терминов](../40-moc/glossary.md)
