### Коллекции

- https://cpp.libhunt.com/
- Логирование
  - https://cpp.libhunt.com/libs/logging
- https://github.com/fenbf/AwesomePerfCpp

### Makefile

- https://makefiletutorial.com/

### Библиотеки

- HTTP запросы
  - https://github.com/libcpr/cpr
- HTTP Серверы
  - https://github.com/yhirose/cpp-httplib
- JSON
  - https://github.com/nlohmann/json
- Встраиваемые БД
  - Key-Value
    - https://github.com/facebook/rocksdb
    - https://github.com/google/leveldb
- Комплексные
  - Abseil - это открытая библиотека C++, соответствующая стандарту C++17, которая разработана Google для расширения стандартной библиотеки C++ и включает проверенный на практике код, используемый в собственной кодовой базе компании. https://github.com/abseil/abseil-cpp
- Логирование
  - https://github.com/gabime/spdlog
  - https://github.com/log4cplus/log4cplus
  - Проект Glog имел успешный старт, однако не достиг долгосрочного развития. Несмотря на это, он послужил источником идей для других проектов. Данная система может быть эффективно применена в небольших проектах с низкими требованиями к производительности, таких как служебные утилиты и миниатюрные разработки. https://github.com/google/glog
  - https://github.com/SergiusTheBest/plog
  - https://github.com/Carabasen/ulog
  - https://github.com/3Hren/blackhole
  - Easylogging представляет собой развивающийся проект, в котором ряд функциональных возможностей требует дальнейшей доработки. Несмотря на потенциал для будущего развития, в текущем состоянии инструмент обладает недостаточной степенью завершенности для широкого практического применения. https://github.com/abumq/easyloggingpp
  - P7 — серьезный проект, заточенный в первую очередь на сетевое использование и проекты от маленьких embedded до больших систем. Поддержка несколькиз языков, точный контроль памяти и удаленное управление, превосходная производительность, телеметрия делают его очень предпочтительным кандидатом для целого спектра задач (кроме пожалуй мелких утилит и скромных home проектов). Принцип – пишем все, а разберемся потом. Так же стоит отметить, что размер итогового файла (если Sink сконфигурирован на использование бинарныго файла) меньше файлов записанных другими протестированными логерами в несколько раз (5-7) https://baical.net/p7.html
  - https://log4cpp.sourceforge.net/

### Песочницы

- http://coliru.stacked-crooked.com/
- https://www.onlinegdb.com/online_c++_compiler
- https://www.programiz.com/cpp-programming/online-compiler/
- https://onecompiler.com/cpp
- https://cpp.sh/
- https://cppinsights.io/
- https://rextester.com/l/cpp_online_compiler_gcc
- https://www.jdoodle.com/online-compiler-c++/
- https://onecompiler.com/cpp
- https://replit.com/languages/cpp
- https://www.codechef.com/ide
- https://www.mycompiler.io/new/cpp
- https://www.cppbuzz.com/compiler/online-c++-compiler
- https://paiza.io/en/projects/new?language=cpp

### Compiler explorer

- https://godbolt.org/

### Книги

- https://craftinginterpreters.com/
- Programming with C++20 - Concepts, Coroutines, Ranges, and more https://andreasfertig.com/books/programming-with-cpp20/

### Курсы

- https://ravesli.com/uroki-cpp/

### Блоги

- https://www.cppstories.com/
- https://nullprogram.com/
- https://www.cs.swarthmore.edu/~newhall/unixhelp/
- https://leimao.github.io/blog/
- https://geidav.wordpress.com/category/c/
- https://isocpp.org/blog
- https://www.ramtintjb.com/blog
- https://andreasfertig.com/blog/tag/cpp/
- https://twdev.blog/
- http://cukic.co/c++/
- https://embeddedartistry.com/blog/
- https://vorbrodt.blog/
- https://lcellentani.github.io/
- https://www.fluentcpp.com/posts/
- https://shaharmike.com/cpp/
- https://nullprogram.com/index/
- https://codeyarns.com/tech/index.html#cpp&gsc.tab=0
- https://abseil.io/tips/
- https://nimrod.blog/

### Статьи

- Основы
  - Основное
    - Статическая типизация и преобразования типов https://metanit.com/cpp/tutorial/2.4.php
    - Указатели и ссылки в языке C++ https://sysprog.ru/post/ukazateli-i-ssylki-v-yazyke-c
    - Урок №80. Указатели https://ravesli.com/urok-80-ukazateli-vvedenie/
    - Упрощённое руководство по работе с памятью Си https://habr.com/ru/articles/711458/
  - Компиляция
    - О GCC, компиляции и библиотеках часть 2 https://uzverss.livejournal.com/57883.html
  - RAII
    - Концепция RAII (Resource Acquisition Is Initialization) https://habr.com/ru/companies/otus/articles/778942/
    - Идиома RAII и умные указатели https://education.yandex.ru/handbook/cpp/article/raii-and-smart-pointers
  - Exceptions
    - Understanding the .gcc_except_table section in ELF binaries (GCC) https://martin.uy/blog/understanding-the-gcc_except_table-section-in-elf-binaries-gcc/
    - How to Handle Exceptions in C++ https://rollbar.com/guides/cpp/how-to-handle-exceptions-in-cpp/
    - How McSema Handles C++ Exceptions https://blog.trailofbits.com/2019/01/21/how-mcsema-handles-c-exceptions/
    - The Secret Life of C++: Exceptions https://web.mit.edu/tibbetts/Public/inside-c/www/exceptions.html
    - An Introduction to Stack Unwinding and Exception Handling https://www.zyma.me/post/stack-unwind-intro/
  - Корутины, coroutines
    - Deep Dive into C++20 Coroutines https://medium.com/@threehappyer/deep-dive-into-c-20-coroutines-ef5a557d15cb
    - C++20. Coroutines https://habr.com/ru/articles/519464/
    - C++20 Coroutines https://dimakorolev.substack.com/p/c20-coroutines
  - std::unique_lock
    - std::unique_lock https://cplusplus.com/reference/mutex/unique_lock/
    - Mutex lock guards in C++11 https://geidav.wordpress.com/2014/01/09/mutex-lock-guards-in-c11/    
  - Ссылки
    - Категории выражений и виды ссылок https://pvs-studio.ru/ru/blog/terms/6517/
    - Understanding lvalues, rvalues and their references https://www.fluentcpp.com/2018/02/06/understanding-lvalues-rvalues-and-their-references/
    - Lvalues and Rvalues (C++) https://learn.microsoft.com/en-us/cpp/cpp/lvalues-and-rvalues-visual-cpp?view=msvc-170
    - Understanding Lvalues, PRvalues and Xvalues in C/C++ with Examples https://www.geeksforgeeks.org/understanding-lvalues-prvalues-and-xvalues-in-ccwith-examples/
    - Value Categories in C++17 https://medium.com/@barryrevzin/value-categories-in-c-17-f56ae54bccbe
    - Категории выражений в C++ https://habr.com/ru/articles/441742/
    - “New” Value Terminology Bjarne Stroustrup https://www.stroustrup.com/terminology.pdf
    - The Story of Value Categories in C++ | Ray https://oneraynyday.github.io/dev/2020/07/03/Value-Categories/
    - lvalues, rvalues, glvalues, prvalues, xvalues, помогите! - https://habr.com/ru/articles/869854/
  - Perfect Forwarding
    - Perfect Forwarding https://levelup.gitconnected.com/perfect-forwarding-647e1caaf879
    - Understanding Move Semantics and Perfect Forwarding: Part 3 https://drewcampbell92.medium.com/understanding-move-semantics-and-perfect-forwarding-part-3-65575d523ff8
  - Перемещение
    - std:forward
      - Функция std::forward https://pvs-studio.ru/ru/blog/terms/6515/  
    - Остальное
      - Углубляемся в C++: move семантика и rvalue https://tproger.ru/articles/move-semantics-and-rvalue
      - What is a Move Constructor in C++? https://www.scaler.com/topics/cpp-move-constructor/
  - Умные указатели, smart pointers
    - Основное
      - Prefer unique_ptr over shared_ptr unless you need to share ownership https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Rr-unique
      - About smart pointers in C++ https://www.deleaker.com/blog/2018/08/27/about-smart-pointers-in-c/
      - A Complete Guide to Smart Pointers in C++ https://iies.in/blog/a-complete-guide-to-smart-pointers-in-c/
    - std::weak_ptr
      - https://en.cppreference.com/w/cpp/memory/weak_ptr
    - std::shared_ptr
      - In-depth look at C++ shared pointers https://vorbrodt.blog/2019/10/13/in-depth-look-at-c-shared-pointers/
      - When exactly does the std::shared_ptr take ownership? https://vorbrodt.blog/2019/10/14/when-exactly-does-the-stdshared_ptr-take-ownership/
      - Understanding the inner workings of C++ smart pointers - The shared_ptr https://andreasfertig.com/blog/2024/09/understanding-the-inner-workings-of-cpp-smart-pointers-the-shared_ptr/
      - C++ Shared Pointer Thread-Safety https://leimao.github.io/blog/CPP-Shared-Ptr-Thread-Safety/
      - Of common problems with shared pointers https://twdev.blog/2024/09/sharedptr/
      - std::shared_ptr and shared_from_this https://embeddedartistry.com/blog/2017/01/11/stdshared_ptr-and-shared_from_this/
      - Exploring std::shared_ptr https://shaharmike.com/cpp/shared-ptr/
    - Остальное
      - Singletons, shared instances, the modern way http://cukic.co/2013/06/26/singletons-shared-instances-the-modern-way/
  - VTT
    - C++ Virtual Table Tables(VTT) https://nimrod.blog/posts/cpp-virtual-table-tables/
  - Condition variables
    - std::condition_variable https://ru.cppreference.com/w/cpp/thread/condition_variable
    - How-to: Use C++ Conditional Variables for Thread Synchronization https://jtchen.io/blog/cpp-conditional-variables
    - C++ Condition Variable https://leimao.github.io/blog/CPP-Condition-Variable/
  - date
    - Time in C++ – present and future – Part 2 https://curiouslyrecurringthoughts.home.blog/2019/08/30/time-in-c-present-and-future-part-2/
  - Шаблоны, templates
    - Шаблоны https://education.yandex.ru/handbook/cpp/article/templates
  - SFINAE (Substitution Failure Is Not An Error - подстановка, не являющаяся ошибкой)
  - Многопоточное программирование
    - Мьютексы, Mutexes
      - Multithreading in C++: Mutexes https://www.ramtintjb.com/blog/Mutexes
      - Mutex in C++: the story so far – Part 2 https://curiouslyrecurringthoughts.home.blog/2019/07/21/mutex-in-c-the-story-so-far-part-2/
    - Остальное
      - Multithreading in C++: Memory Ordering https://www.ramtintjb.com/blog/memory-ordering
  - Исключения, Exceptions
    - Обработка исключений https://education.yandex.ru/handbook/cpp/article/exceptions
  - Стиль программирования
    - On Using Guards in C++ https://www.fluentcpp.com/2018/02/20/on-using-guards-in-cpp/
  - undefined behavior
    - Путеводитель C++ программиста по неопределённому поведению https://pvs-studio.ru/ru/blog/posts/cpp/1215/
  - Остальное
    - What does C++ Object Layout Look Like? https://nimrod.blog/posts/what-does-cpp-object-layout-look-like/
    - Безопасное использование C++ https://habr.com/ru/companies/pvs-studio/articles/580762/
    - C++ quick tips: Overloaded virtual functions https://twdev.blog/2024/07/cpp_overloaded_virtuals/
    - Всё, точка, приплыли! Учимся работать с числами с плавающей точкой и разрабатываем альтернативу с фиксированной точностью десятичной дроби https://habr.com/ru/companies/xakep/articles/257897/
- Linux
  - epoll
    - Concurrent HTTP Server with Epoll https://kaleid-liner.github.io/blog/2019/06/02/epoll-web-server.html
    - Illuminating synchronization edges for ThreadSanitizer https://nullprogram.com/blog/2022/10/03/
    - Epoll and IO Multiplexing https://noneback.github.io/blog/epoll-and-io复用/
    - Socket https://www.xuxueli.com/blog/?blog=./notebook/3-网络/Socket.md
    - Анализ исходного кода ядра Linux: epoll https://blog.hongxiaolong.com/posts/epoll.html
- Package management, Менеджеры пакетов
  - #1 The state of C++ package management: The big three https://twdev.blog/2024/08/cpp_pkgmng1/
- Отладка
  - Valgrind
    - Выявление ошибок в работе с памятью в C и C++: Сравниваем Sanitizers и Valgrind https://habr.com/ru/companies/otus/articles/801123/
  - GDB
    - Шпаргалка полезных команд GDB https://habr.com/ru/articles/535960/
    - Дайте мне 15 минут, и я изменю ваш взгляд на GDB https://habr.com/ru/articles/824638/
- Логирование, Logging
  - Основное
    - Сравнение библиотек логирования https://habr.com/ru/articles/313686/
    - Questions to be answered before integrating logging library into your C++ project. https://iryna-mykytyn.medium.com/integrate-logging-into-your-c-project-do-it-right-do-it-once-9a9b0c5a8383
  - glog
    - How To Use Google Logging Library (glog) https://rpg.ifi.uzh.ch/docs/glog.html
    - How to install and use GLog https://codeyarns.com/tech/2017-10-26-how-to-install-and-use-glog.html#gsc.tab=0
    - Glog Source Code Reading Notes https://nimrod.blog/posts/glog-source-code-reading/
  - plog
    - Plog - portable and simple log for C++ https://www.codeproject.com/Articles/992287/Plog-portable-and-simple-log-for-Cplusplus
  - Остальное
    - Devlog: Writing a Logging Library in C++ https://gotz.medium.com/devlog-writing-a-logging-library-in-c-9601ec3699eb
    - Top C++ Logging Libraries Compared: How to Choose the Best One - part 1 https://c-and-beyond.hashnode.dev/top-c-logging-libraries-compared-how-to-choose-the-best-one-part-1
    - Logger C++ https://habr.com/ru/articles/838412/
    - Logging without Compromising Performance https://medium.com/software-architecture-foundations/logging-without-compromising-performance-3ab4d9ac3caa
- Сокеты, Sockets
  - Основное
  - Остальное
    - Some notes on Sockets programming https://cybersect.substack.com/p/some-notes-on-sockets-programming
- Профилирование, Profiling
  - gperftools
    - Profiling with gperftools https://wiki.geany.org/howtos/profiling/gperftools
    - Profiling with GPerfTools https://developer.ridgerun.com/wiki/index.php/Profiling_with_GPerfTools
  - Остальное
    - Профилирование в облаке и не только https://habr.com/ru/articles/536100/
- Оптимизация, Optimization
  - Основное
    - Немного размышлений и советов по оптимизации кода на С++ https://habr.com/ru/companies/vk/articles/279449/
    - Compilers - What Every Programmer Should Know About Compiler Optimizations https://learn.microsoft.com/en-us/archive/msdn-magazine/2015/february/compilers-what-every-programmer-should-know-about-compiler-optimizations
    - Optimizations in C++ Compilers https://queue.acm.org/detail.cfm?id=3372264
    - Optimizing software in C++ An optimization guide for Windows, Linux, and Mac platforms https://www.agner.org/optimize/optimizing_cpp.pdf
  - RVO (Return Value Optimization)
    - How to Return Values Effectively in C++ https://nimrod.blog/posts/how-to-return-values-effectively-in-c++/
    - Return value optimization (RVO) https://sigcpp.github.io/2020/06/08/return-value-optimization
    - RVO и NRVO https://pvs-studio.ru/ru/blog/terms/6516/
    - Return Value Optimization (RVO) https://lcellentani.github.io/post/cpp_rvo/
    - Return value optimizations https://www.fluentcpp.com/2016/11/28/return-value-optimizations/
    - Return Value Optimization https://shaharmike.com/cpp/rvo/    
- Системы сборки
  - Bazel
    - Основное
      - Understanding Bazel: An Introductory Overview https://medium.com/@d.s.m/understanding-bazel-an-introductory-overview-0c9ddb1b1ce9
      - Собираем C++ с bazel https://habr.com/ru/articles/489566/
    - rules_foreign_cc
      - How to use the make rule from rules_foreign_cc repository for bazel https://www.hdlfactory.com/post/2023/06/13/how-to-use-the-make-rule-from-rules_foreign_cc-repository-for-bazel/
      - Adding a Dependency Based on Autotools to a Bazel Project https://bloggerbust.ca/post/adding-a-dependency-based-on-autotools-to-a-bazel-project/
  - CMake; генератор систем сборки
    - C++ Quickstart With CMake https://abseil.io/docs/cpp/quickstart-cmake
    - Шпаргалка по CMake https://ps-group.github.io/cxx/cmake_cheatsheet
    - Полное руководство по CMake. Часть первая: Синтаксис https://telegra.ph/Polnoe-rukovodstvo-po-CMake-CHast-pervaya-Sintaksis-02-27
    - Полное руководство по CMake. Часть вторая: Система сборки https://web.archive.org/web/20220528140444/https://habr.com/en/post/432096/
  - Make, Makefile
    - GNU make https://www.gnu.org/software/make/manual/make.html
    - Makefile для самых маленьких https://habr.com/ru/articles/155201/
    - Makefile Tutorials and Examples to Build From https://earthly.dev/blog/make-tutorial/
    - Learn Makefiles With the tastiest examples https://makefiletutorial.com/
    - Understanding Makefiles: How They Work and Why You Need Them https://shawnguyen.medium.com/understanding-makefiles-how-they-work-and-why-you-need-them-4b2071f0dfac
    - Using make and writing Makefiles https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html
    - A Simple Makefile Tutorial https://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
    - Tutorial on writing makefiles https://www.math.colostate.edu/~yzhou/computer/writemakefile.html
- Swiss Tables
  - Swiss Tables and absl::Hash https://abseil.io/blog/20180927-swisstables
- Библиотеки
  - userver
- Примеры приложений
  - Пишем свой pastebin, используя только userver https://habr.com/ru/companies/yandex/articles/894294/
- Подборки
  - Подборка крутых докладов по С++ за 2023 год https://pvs-studio.ru/ru/blog/posts/1120/
- Остальное
  - Tip of the Week #176: Prefer Return Values to Output Parameters https://abseil.io/tips/176
  - Compiler Explorer — уникальный проект для исследования компилируемого кода https://habr.com/ru/companies/ruvds/articles/815675/
  - Bit Twiddling Hacks, By Sean Eron Anderson http://graphics.stanford.edu/~seander/bithacks.html##ValueInWord
  - More Hash Function Tests https://aras-p.info/blog/2016/08/09/More-Hash-Function-Tests/
  - Ввод-вывод в Unix-подобных ОС (примеры) https://zed.karelia.ru/go.to/for.students/computer.networks/io.examples
  - 20 ловушек переноса Си++ - кода на 64-битную платформу. https://club.shelek.ru/viewart.php?id=302

### Видео

- Разработка, программирование, обучение - это то немногое что вы можете здесь найти. https://www.youtube.com/@Ice.Rezzet/videos
  - C++ Быстрый старт. #11.1. Компиляция и сборка приложения https://www.youtube.com/watch?v=w4TQdL3OGe8
- Семинары 238 группы по акосу https://www.youtube.com/watch?v=5lqdXNpKEag&list=PLdW86-ZDBvbU0_J255GNYi1YVUW_GoKmH
- Семинары 226 группы ФКН ПМИ https://www.youtube.com/watch?v=WGxA9WTWyNQ&list=PLdW86-ZDBvbUrgXfGyETuC3qU3TrEHaP5

### Stackoverflow

- What are rvalues, lvalues, xvalues, glvalues, and prvalues? https://stackoverflow.com/questions/3601602/what-are-rvalues-lvalues-xvalues-glvalues-and-prvalues