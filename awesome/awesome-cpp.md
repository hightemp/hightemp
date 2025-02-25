### Коллекции

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

### Книги

- https://craftinginterpreters.com/
- Programming with C++20 - Concepts, Coroutines, Ranges, and more https://andreasfertig.com/books/programming-with-cpp20/

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

### Статьи

- Основы
  - Основное
  - Корутины, coroutines
    - Deep Dive into C++20 Coroutines https://medium.com/@threehappyer/deep-dive-into-c-20-coroutines-ef5a557d15cb
    - C++20. Coroutines https://habr.com/ru/articles/519464/
  - std::unique_lock
    - std::unique_lock https://cplusplus.com/reference/mutex/unique_lock/
    - Mutex lock guards in C++11 https://geidav.wordpress.com/2014/01/09/mutex-lock-guards-in-c11/    
  - Ссылки
    - Категории выражений и виды ссылок https://pvs-studio.ru/ru/blog/terms/6517/
  - std:forward
    - Функция std::forward https://pvs-studio.ru/ru/blog/terms/6515/
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
    - Остальное
      - Singletons, shared instances, the modern way http://cukic.co/2013/06/26/singletons-shared-instances-the-modern-way/
  - Condition variables
    - std::condition_variable https://ru.cppreference.com/w/cpp/thread/condition_variable
    - How-to: Use C++ Conditional Variables for Thread Synchronization https://jtchen.io/blog/cpp-conditional-variables
    - C++ Condition Variable https://leimao.github.io/blog/CPP-Condition-Variable/
  - date
    - Time in C++ – present and future – Part 2 https://curiouslyrecurringthoughts.home.blog/2019/08/30/time-in-c-present-and-future-part-2/
  - Шаблоны, templates
    - Шаблоны https://education.yandex.ru/handbook/cpp/article/templates
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
  - Остальное
    - Путеводитель C++ программиста по неопределённому поведению https://pvs-studio.ru/ru/blog/posts/cpp/1215/
    - C++ quick tips: Overloaded virtual functions https://twdev.blog/2024/07/cpp_overloaded_virtuals/
    - Всё, точка, приплыли! Учимся работать с числами с плавающей точкой и разрабатываем альтернативу с фиксированной точностью десятичной дроби https://habr.com/ru/companies/xakep/articles/257897/
- Package management, Менеджеры пакетов
  - #1 The state of C++ package management: The big three https://twdev.blog/2024/08/cpp_pkgmng1/
- RAII
  - Концепция RAII (Resource Acquisition Is Initialization) https://habr.com/ru/companies/otus/articles/778942/
  - Идиома RAII и умные указатели https://education.yandex.ru/handbook/cpp/article/raii-and-smart-pointers
- Профилирование, Profiling
  - gperftools
    - Profiling with gperftools https://wiki.geany.org/howtos/profiling/gperftools
    - Profiling with GPerfTools https://developer.ridgerun.com/wiki/index.php/Profiling_with_GPerfTools
  - Остальное
    - Профилирование в облаке и не только https://habr.com/ru/articles/536100/
- Оптимизация, Optimization
  - Основное
    - Немного размышлений и советов по оптимизации кода на С++ https://habr.com/ru/companies/vk/articles/279449/
  - RVO
    - RVO и NRVO https://pvs-studio.ru/ru/blog/terms/6516/
    - Return Value Optimization (RVO) https://lcellentani.github.io/post/cpp_rvo/
    - Return value optimizations https://www.fluentcpp.com/2016/11/28/return-value-optimizations/
- CMake
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
- Exceptions
  - Understanding the .gcc_except_table section in ELF binaries (GCC) https://martin.uy/blog/understanding-the-gcc_except_table-section-in-elf-binaries-gcc/
  - How to Handle Exceptions in C++ https://rollbar.com/guides/cpp/how-to-handle-exceptions-in-cpp/
  - How McSema Handles C++ Exceptions https://blog.trailofbits.com/2019/01/21/how-mcsema-handles-c-exceptions/
  - The Secret Life of C++: Exceptions https://web.mit.edu/tibbetts/Public/inside-c/www/exceptions.html
  - An Introduction to Stack Unwinding and Exception Handling https://www.zyma.me/post/stack-unwind-intro/
- Подборки
  - Подборка крутых докладов по С++ за 2023 год https://pvs-studio.ru/ru/blog/posts/1120/
- Остальное
  - Bit Twiddling Hacks, By Sean Eron Anderson http://graphics.stanford.edu/~seander/bithacks.html##ValueInWord
  - More Hash Function Tests https://aras-p.info/blog/2016/08/09/More-Hash-Function-Tests/
  - Ввод-вывод в Unix-подобных ОС (примеры) https://zed.karelia.ru/go.to/for.students/computer.networks/io.examples

### Видео

- Разработка, программирование, обучение - это то немногое что вы можете здесь найти. https://www.youtube.com/@Ice.Rezzet/videos
  - C++ Быстрый старт. #11.1. Компиляция и сборка приложения https://www.youtube.com/watch?v=w4TQdL3OGe8