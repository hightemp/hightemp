## **I. Основы**

### **1. Введение в Android-разработку**

*   **1.1. Что такое Android?**
    *   История и эволюция операционной системы Android.
    *   Различные версии Android и их ключевые особенности.
    *   Архитектура Android: Linux Kernel, Hardware Abstraction Layer (HAL), Android Runtime (ART), Native Libraries, Application Framework, Applications.
    *   Экосистема Android: Google Play Store, производители устройств, разработчики, пользователи.
*   **1.2. Инструменты разработки:**
    *   **Android Studio:**
        *   Установка и настройка Android Studio.
        *   Обзор интерфейса и основных инструментов (Project View, Editor, Logcat, Debugger, Layout Editor, etc.).
        *   Управление проектами, сборка и запуск приложений.
        *   Использование эмулятора и реальных устройств.
        *   Системы контроля версий (Git) в Android Studio.
    *   **Android SDK (Software Development Kit):**
        *   Состав SDK: build tools, platform tools, system images, etc.
        *   Управление компонентами SDK с помощью SDK Manager.
        *   Работа с различными API levels.
    *   **Gradle:**
        *   Основы системы сборки Gradle.
        *   Структура Gradle-файлов (build.gradle, settings.gradle).
        *   Управление зависимостями.
        *   Создание различных сборок (debug, release).
*   **1.3. Создание первого приложения:**
    *   Создание нового проекта в Android Studio.
    *   Структура проекта: `src`, `res`, `manifest`, `build`.
    *   Основные компоненты приложения: Activity, Layout, Resources.
    *   Запуск приложения на эмуляторе или устройстве.
    *   Отладка приложения с помощью Logcat и Debugger.

### **2. Языки программирования: Java и Kotlin**

*   **2.1. Java:**
    *   **Основы Java:**
        *   Синтаксис, типы данных, переменные, операторы, управляющие конструкции (if-else, loops).
        *   Объектно-ориентированное программирование (ООП): классы, объекты, наследование, полиморфизм, инкапсуляция, абстракция.
        *   Исключения и обработка ошибок.
        *   Коллекции (List, Set, Map).
        *   Работа со строками.
        *   Ввод-вывод (I/O).
    *   **Продвинутые темы Java:**
        *   Многопоточность (Threads, Runnable).
        *   Сетевое взаимодействие.
        *   Рефлексия.
        *   Generics.
*   **2.2. Kotlin:**
    *   **Введение в Kotlin:**
        *   Преимущества Kotlin над Java.
        *   Совместимость с Java.
        *   Установка и настройка Kotlin.
    *   **Основы Kotlin:**
        *   Синтаксис, типы данных, переменные (val, var), операторы.
        *   Nullable types и операторы безопасного вызова (`?.`, `!!`).
        *   Функции, лямбда-выражения.
        *   Классы и объекты, data classes.
        *   Наследование, интерфейсы.
    *   **Продвинутые темы Kotlin:**
        *   Расширения (Extension Functions).
        *   Корутины (Coroutines) для асинхронного программирования.
        *   DSL (Domain Specific Language).
        *   Delegated properties.
        *   Sealed classes.
        *   Inline functions.

### **3. Основы UI/UX**

*   **3.1. Layouts:**
    *   **XML для создания интерфейсов:**
        *   Основы XML.
        *   Создание и редактирование XML-файлов в Android Studio.
    *   **View и ViewGroup:**
        *   Основные компоненты UI: TextView, EditText, Button, ImageView, etc.
        *   Атрибуты и свойства View.
        *   LinearLayout, RelativeLayout, ConstraintLayout, FrameLayout, GridLayout.
        *   RecyclerView, ListView, ScrollView.
    *   **Работа с ресурсами:**
        *   Размещение ресурсов (layouts, images, strings, colors, styles) в папках `res`.
        *   Доступ к ресурсам из кода и XML.
        *   Поддержка различных экранов (density, size).
        *   Локализация (strings.xml для разных языков).
*   **3.2. User Input:**
    *   Обработка событий (click, touch, etc.).
    *   Listeners and Callbacks.
    *   Работа с клавиатурой, сенсорным вводом.
    *   Gestures.
*   **3.3. Material Design:**
    *   Принципы Material Design.
    *   Использование Material Design компонентов (MaterialButton, TextInputLayout, etc.).
    *   Темы и стили.
    *   Анимации и переходы.
*   **3.4. Accessibility:**
    *   Создание доступных приложений для пользователей с ограниченными возможностями.
    *   Content descriptions.
    *   TalkBack.
*   **3.5. Jetpack Compose (Основы)**
    *   Декларативный подход к созданию UI.
    *   Основные компоненты: `@Composable` функции, `Column`, `Row`, `Box`, `Text`, `Image`, `Button`.
    *   State management в Compose.

## **II. Основные компоненты Android**

### **4. Activities and Fragments**

*   **4.1. Activity:**
    *   Жизненный цикл Activity (onCreate, onStart, onResume, onPause, onStop, onDestroy).
    *   Управление состоянием Activity (onSaveInstanceState, onRestoreInstanceState).
    *   Запуск и взаимодействие между Activities (Intents, startActivity, startActivityForResult).
    *   Task and Back Stack.
*   **4.2. Fragments:**
    *   Жизненный цикл Fragment (onAttach, onCreate, onCreateView, onActivityCreated, etc.).
    *   Взаимодействие между Fragments и Activity.
    *   FragmentManager, FragmentTransaction.
    *   Типы Fragments: DialogFragment, BottomSheetDialogFragment.
    *   Использование ViewPager для управления Fragments.
*   **4.3. Intents and Intent Filters:**
    *   Явные и неявные Intents.
    *   Использование Intents для запуска Activities, Services, Broadcast Receivers.
    *   Intent Filters для регистрации компонентов приложения для обработки определенных Intents.
    *   Передача данных между Activities с помощью Intents (Extras).

### **5. Data Storage**

*   **5.1. Shared Preferences:**
    *   Хранение простых данных в формате ключ-значение.
    *   Сохранение и чтение данных.
*   **5.2. Internal and External Storage:**
    *   Доступ к файловой системе устройства.
    *   Чтение и запись файлов.
    *   Permissions для доступа к хранилищу.
*   **5.3. SQLite Databases:**
    *   Основы реляционных баз данных.
    *   Создание и управление базами данных в Android.
    *   SQLiteOpenHelper, SQLiteDatabase.
    *   Выполнение SQL-запросов (CRUD operations).
    *   Cursor, Content Providers.
*   **5.4. Room Persistence Library:**
    *   Абстракция над SQLite.
    *   Entities, DAOs (Data Access Objects), Database.
    *   Работа с LiveData и RxJava для асинхронного доступа к данным.
*   **5.5. DataStore:**
    *   Альтернатива Shared Preferences для хранения данных в формате ключ-значение.
    *   Preferences DataStore и Proto DataStore.
    *   Асинхронное хранение данных с использованием Kotlin Coroutines и Flow.

### **6. Networking**

*   **6.1. Permissions:**
    *   Запрос разрешений для доступа к сети (INTERNET).
*   **6.2. HTTP Connections:**
    *   Использование HttpURLConnection или OkHttp для выполнения HTTP-запросов (GET, POST, PUT, DELETE).
    *   Обработка ответов сервера (JSON, XML).
*   **6.3. REST APIs:**
    *   Понимание принципов RESTful архитектуры.
    *   Взаимодействие с RESTful API.
*   **6.4. Retrofit:**
    *   Библиотека для упрощения работы с REST APIs.
    *   Определение интерфейсов для API.
    *   Автоматическая сериализация и десериализация JSON (с использованием Gson или Moshi).
    *   Интеграция с RxJava и Coroutines.
*   **6.5. Volley:**
    *   Библиотека от Google для выполнения сетевых запросов.
    *   Управление очередью запросов.
    *   Кеширование.
*   **6.6. WebSockets:**
    *   Установление и поддержка постоянного соединения с сервером.
    *   Отправка и получение сообщений в режиме реального времени.

### **7. Background Tasks and Services**

*   **7.1. Threads and Handlers:**
    *   Создание и управление потоками.
    *   Взаимодействие с UI thread из фоновых потоков с помощью Handlers.
*   **7.2. AsyncTask:**
    *   Упрощенный способ выполнения асинхронных задач.
    *   `doInBackground`, `onProgressUpdate`, `onPostExecute`.
*   **7.3. Services:**
    *   Жизненный цикл Service (onCreate, onStartCommand, onDestroy).
    *   Типы Services: Foreground Service, Background Service, Bound Service.
    *   Взаимодействие с Services (startService, bindService).
    *   IntentService.
*   **7.4. JobScheduler and WorkManager:**
    *   Планирование выполнения задач в фоновом режиме.
    *   WorkManager как рекомендуемый способ выполнения фоновых задач.
    *   Constraints (условия выполнения задачи).
    *   OneTimeWorkRequest, PeriodicWorkRequest.
*   **7.5. AlarmManager:**
    *   Планирование выполнения задач в определенное время.
*   **7.6. Broadcast Receivers:**
    *   Регистрация Broadcast Receivers для прослушивания системных событий (например, изменение состояния сети).
    *   Обработка Broadcast Intents.

### **8. Location and Sensors**

*   **8.1. Location Services:**
    *   Получение текущего местоположения пользователя (GPS, Network).
    *   Permissions (ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION).
    *   Fused Location Provider API.
    *   Geofencing.
*   **8.2. Sensors:**
    *   Доступ к различным датчикам устройства (акселерометр, гироскоп, датчик освещенности, etc.).
    *   SensorManager, SensorEventListener.
    *   Обработка данных от датчиков.

## **III. Продвинутые темы**

### **9. Архитектура приложений**

*   **9.1. MVC (Model-View-Controller):**
    *   Разделение приложения на Model, View, Controller.
*   **9.2. MVP (Model-View-Presenter):**
    *   Разделение приложения на Model, View, Presenter.
    *   Тестирование Presenter.
*   **9.3. MVVM (Model-View-ViewModel):**
    *   Разделение приложения на Model, View, ViewModel.
    *   Использование LiveData или StateFlow для связи View и ViewModel.
    *   Data Binding.
    *   Тестирование ViewModel.
*   **9.4. Clean Architecture:**
    *   Разделение приложения на слои (Entities, Use Cases, Interface Adapters, Frameworks and Drivers).
    *   Независимость от фреймворков и библиотек.
    *   Тестирование Use Cases.
*   **9.5. MVI (Model-View-Intent):**
    *   Однонаправленный поток данных.
    *   Использование StateFlow или RxJava для управления состоянием.

### **10. Jetpack Libraries**

*   **10.1. Navigation Component:**
    *   Упрощение навигации между экранами (Fragments).
    *   NavGraph, NavHostFragment, NavController.
    *   Передача аргументов между экранами.
*   **10.2. Data Binding:**
    *   Связывание данных с UI элементами в XML.
    *   Двустороннее связывание данных.
*   **10.3. LiveData:**
    *   Наблюдаемые данные, учитывающие жизненный цикл компонентов.
    *   Использование LiveData в ViewModel.
*   **10.4. ViewModel:**
    *   Хранение данных, связанных с UI, переживающее изменения конфигурации.
*   **10.5. Paging:**
    *   Постраничная загрузка данных.
    *   PagingSource, Pager, PagingData.
*   **10.6. Hilt:**
    *   Dependency Injection (DI) библиотека, основанная на Dagger.
    *   Упрощение внедрения зависимостей.
    *   @HiltViewModel, @AndroidEntryPoint.
*   **10.7. CameraX:**
    *   Упрощение работы с камерой.
    *   Preview, ImageCapture, ImageAnalysis.
*   **10.8. Jetpack Compose:**
    *   **Продвинутые темы:**
        *   Layouts: `ConstraintLayout`, `Custom Layouts`.
        *   Theming: `MaterialTheme`, `Custom Themes`.
        *   Animations: `AnimatedVisibility`, `Transitions`, `Custom Animations`.
        *   Gestures: `Draggable`, `Swipeable`.
        *   Testing: `Compose Test Rule`, `UI Tests`.
        *   Interoperability with existing Views.
        *   Navigation in Compose.

### **11. Тестирование**

*   **11.1. Unit Testing:**
    *   JUnit, Mockito.
    *   Тестирование бизнес-логики, ViewModels, Repositories.
*   **11.2. UI Testing:**
    *   Espresso, UI Automator.
    *   Тестирование взаимодействия пользователя с UI.
    *   Jetpack Compose Testing.
*   **11.3. Integration Testing:**
    *   Тестирование взаимодействия между различными компонентами приложения.
*   **11.4. End-to-End Testing:**
    *   Тестирование всего приложения целиком.

### **12. Безопасность**

*   **12.1. Secure Data Storage:**
    *   Шифрование данных (EncryptedSharedPreferences, Jetpack Security).
    *   Использование Keystore для хранения ключей шифрования.
*   **12.2. Network Security:**
    *   HTTPS.
    *   SSL Pinning.
*   **12.3. Permissions:**
    *   Запрос разрешений в runtime.
    *   Обработка случаев, когда пользователь не предоставил разрешение.
*   **12.4. Obfuscation and Code Protection:**
    *   ProGuard, R8.
    *   Защита от обратной инженерии.
*   **12.5. Security Best Practices:**
    *   OWASP Mobile Top 10.
    *   Регулярное обновление зависимостей.

### **13. Производительность**

*   **13.1. Profiling:**
    *   Android Profiler.
    *   Анализ использования CPU, памяти, сети, батареи.
*   **13.2. Memory Management:**
    *   Утечки памяти (Memory Leaks).
    *   WeakReference, SoftReference.
*   **13.3. Battery Optimization:**
    *   Doze and App Standby.
    *   Оптимизация фоновых задач.
*   **13.4. Rendering Performance:**
    *   GPU Profiler.
    *   Оптимизация layouts.
    *   Overdraw.
*   **13.5. ANR (Application Not Responding):**
    *   Выявление и исправление ANR.

### **14. Публикация приложения**

*   **14.1. Подготовка к релизу:**
    *   Тестирование.
    *   Оптимизация.
    *   Уменьшение размера приложения (App Bundles).
*   **14.2. Подписание приложения:**
    *   Создание Keystore.
    *   Подписание приложения с помощью Keystore.
*   **14.3. Google Play Console:**
    *   Создание аккаунта разработчика.
    *   Загрузка приложения в Google Play Console.
    *   Создание страницы приложения (описание, скриншоты, видео).
    *   Установка цены и модели распространения.
    *   Публикация приложения (Alpha, Beta, Production).
    *   Мониторинг отзывов и статистики.
*   **14.4. A/B Testing:**
    *   Тестирование различных версий приложения для определения наиболее эффективной.
*   **14.5. Firebase:**
    *   Firebase Crashlytics для отслеживания ошибок.
    *   Firebase Analytics для анализа поведения пользователей.
    *   Firebase Cloud Messaging (FCM) для отправки push-уведомлений.
    *   Firebase Remote Config для удаленного изменения параметров приложения.

## **IV. Дополнительные темы**

*   **15. Kotlin Multiplatform Mobile (KMM):**
    *   Разработка общего кода для Android и iOS приложений на Kotlin.
*   **16. Flutter:**
    *   Кросс-платформенный фреймворк для разработки мобильных приложений на языке Dart.
*   **17. React Native:**
    *   Кросс-платформенный фреймворк для разработки мобильных приложений на JavaScript.
*   **18. CI/CD (Continuous Integration / Continuous Deployment):**
    *   Автоматизация сборки, тестирования и развертывания приложений.
    *   GitHub Actions, GitLab CI, Jenkins, Bitrise.
*   **19. Wear OS:**
    *   Разработка приложений для носимых устройств.
*   **20. Android TV:**
    *   Разработка приложений для телевизоров.
*   **21. Android Auto:**
    *   Разработка приложений для автомобилей.
*   **22. ARCore:**
    *   Разработка приложений с дополненной реальностью.
*   **23. ML Kit:**
    *   Интеграция моделей машинного обучения в Android-приложения.
