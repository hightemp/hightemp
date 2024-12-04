### Коллекции

- https://github.com/heynickc/awesome-ddd

### Термины

- Основные концептуальные термины:
    - Domain (Домен) - это предметная область, для которой разрабатывается программное обеспечение
    - Domain Model (Доменная модель) - абстракция, которая инкапсулирует сложную бизнес-логику и отражает реальность бизнеса в коде
    - Bounded Context (Ограниченный контекст) - четкие границы, в которых определенные термины и модели имеют конкретное значение
- Стратегические элементы DDD:
    - Strategic Design (Стратегическое проектирование) - подход к организации крупных доменов в сеть ограниченных контекстов
    - Ubiquitous Language (Единый язык) - общий язык между разработчиками, экспертами предметной области и другими заинтересованными сторонами
    - Generic Domains (Общие домены) - универсально применимые концепции, встречающиеся во многих бизнесах
- Тактические паттерны и элементы:
    - Entities (Сущности) - классы, моделирующие концепции домена и имеющие идентичность
    - Value Objects (Объекты-значения)
    - Aggregates (Агрегаты)
    - Domain Events (Доменные события)
    - Repositories (Репозитории)
    - Services (Сервисы)
- Дополнительные концепции:
    - Command Query Responsibility Segregation (CQRS) - разделение ответственности команд и запросов
    - Event Sourcing - подход к хранению состояния системы как последовательности событий
    - Event Storming - метод коллективного исследования домена
- Паттерны
    - Стратегические паттерны (Strategic Patterns):
        - Bounded Context (Ограниченный контекст) - определяет границы применения моделей и терминологии
        - Ubiquitous Language (Единый язык) - общий язык для коммуникации между всеми участниками проекта
        - Context Mapping - определяет отношения между различными ограниченными контекстами
        - Core Domain (Основной домен) - выделение критически важной части бизнес-логики
    - Тактические паттерны (Tactical Patterns):
        - Entities (Сущности) - объекты, имеющие уникальную идентичность
        - Value Objects (Объекты-значения) - объекты, определяемые их атрибутами
        - Aggregates (Агрегаты) - кластеры связанных объектов, рассматриваемых как единое целое
        - Domain Events (Доменные события) - события, значимые для экспертов предметной области
        - Repositories (Репозитории) - абстракции для доступа к данным
        - Factories (Фабрики) - паттерны для создания сложных объектов
    - Архитектурные паттерны:
        - Layered Architecture (Многослойная архитектура) - разделение приложения на слои
        - Hexagonal Architecture (Гексагональная архитектура) - изоляция домена от внешних зависимостей
        - CQRS (Command Query Responsibility Segregation) - разделение операций чтения и записи
    - Поведенческие паттерны:
        - Specification Pattern (Спецификация) - для инкапсуляции бизнес-правил
        - Policy Pattern (Политика) - для реализации вариативного поведения
        - State Pattern (Состояние) - для управления состоянием объектов
    - Интеграционные паттерны:
        - Anti-corruption Layer (Антикоррупционный слой) - защита модели от внешних влияний
        - Shared Kernel (Общее ядро) - совместно используемые части модели между контекстами
        - Customer/Supplier (Заказчик/Поставщик) - определение отношений между командами

### Статьи

- Паттерны
    - Стратегические паттерны (Strategic Patterns):
        - Bounded Context (Ограниченный контекст)
            - Bounded Context https://martinfowler.com/bliki/BoundedContext.html
            - Understanding the Bounded Context in Microservices https://blog.bitsrc.io/understanding-the-bounded-context-in-microservices-c70c0e189dd1
            - What is Bounded Context? https://www.dremio.com/wiki/bounded-context/
            - A practical guide to Subdomains and Bounded Contexts https://medium.com/@ricardo.ferraris/a-practical-guide-to-subdomains-and-bounded-contexts-cb27ef5790ca
    - Остальное
        - Policy pattern; Policy pattern является альтернативным названием для паттерна Strategy (Стратегия)
            - Domain Policy for Domain-Driven Design https://www.codeproject.com/Tips/1175911/Domain-Policy-for-Domain-Driven-Design
- Domain events
    - Domain events: Design and implementation https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/domain-events-design-implementation
- Остальное
    - Domain-Driven Design (DDD) Paradigm: Introduction to Domain-Driven Design https://dev.to/ruben_alapont/domain-driven-design-ddd-paradigm-introduction-to-domain-driven-design-4l9g
    - Best Practice - An Introduction To Domain-Driven Design https://learn.microsoft.com/en-us/archive/msdn-magazine/2009/february/best-practice-an-introduction-to-domain-driven-design
    - Domain Driven Design and Development In Practice https://www.infoq.com/articles/ddd-in-practice/
    - Unraveling the Mysteries of Domain-Driven Design: An Introduction https://dev.to/scovic/unraveling-the-mysteries-of-domain-driven-design-an-introduction-f2n
    - DDD 101 — The 5-Minute Tour https://medium.com/the-coding-matrix/ddd-101-the-5-minute-tour-7a3037cf53b8
    - DOMAIN-DRIVEN DESIGN (DDD) https://redis.io/glossary/domain-driven-design-ddd/
    - What is Domain-Driven Design (DDD)? Concepts, Models & Examples https://em360tech.com/tech-article/what-is-domain-driven-design-ddd
    - Domain-Driven Design (DDD): Strategic Design Explained https://medium.com/@lambrych/domain-driven-design-ddd-strategic-design-explained-55e10b7ecc0f
    - Domain-Driven Design (DDD): From Customer Ideas to Code https://medium.com/@codebob75/domain-driven-design-ddd-from-customer-ideas-to-code-a83a005326e9
    - 1 Domain-Driven Design (DDD): A Summary https://softengbook.org/articles/ddd
    - Domain-Driven Design (DDD) https://www.geeksforgeeks.org/domain-driven-design-ddd/
    - Domain-Driven Design (DDD): A Guide to Building Scalable, High-Performance Systems https://romanglushach.medium.com/domain-driven-design-ddd-a-guide-to-building-scalable-high-performance-systems-5314a7fe053c
    - DDD Aggregates - Best Practices and Implementation Strategies https://alinabo.com/ddd-aggregates
    - Understanding Domain-Driven Design: A Practical Approach for Modern Software Architecture https://sensiolabs.com/blog/2024/understanding-domain-driven-design
    - Introduction to domain driven design (DDD) + glossary https://www.rst.software/blog/introduction-to-domain-driven-design-ddd-glossary
    - Domain Driven Design (DDD): Core concepts and Enterprise Architecture https://alok-mishra.com/2021/06/30/domain-driven-design-ddd-core-concepts-explained/
    - Comparing Canonical DDD and Clean DDD https://medium.com/unil-ci-software-engineering/comparing-canonical-ddd-and-clean-ddd-34e807f4e336

### Видео

- Implementing DDD on a React Project https://youtu.be/2qWKLfFpSKQ