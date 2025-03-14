
### Коллекции

- https://github.com/tomhuang12/awesome-k8s-resources
- https://github.com/ramitsurana/awesome-kubernetes
- https://ramitsurana.github.io/awesome-kubernetes/projects/projects/
- https://awesome-architecture.com/devops/kubernetes/kubernetes/
- https://github.com/run-x/awesome-kubernetes

### Статьи

- Основное
    - Основы Kubernetes https://habr.com/ru/articles/258443/
    - What is Kubernetes? https://www.digitalocean.com/community/tutorials/an-introduction-to-kubernetes
- СonfigMaps
    - Управление конфигурацией приложений ConfigMap в Kubernetes https://www.itworkroom.com/configmap_k8s/
    - Kubernetes ConfigMaps и Secrets: как правильно управлять конфигурацией и секретами в кластере https://habr.com/ru/companies/beeline_cloud/articles/864222/
    - K8s - ConfigMap, Secrets https://nixhub.ru/posts/k8s-configmap-basics/
- helm
    - Основное
    - chart
        - From Zero to Hero: A Beginner’s Guide to Creating Helm Charts https://medium.com/@reach2shristi.81/from-zero-to-hero-a-beginners-guide-to-creating-helm-charts-c17d7048ce85
    - Остальное
- Паттерны
    - Основное
        - 10 антипаттернов деплоя в Kubernetes: распространенные практики, для которых есть другие решения https://cloud.vk.com/blog/antipatterny-deploya-v-kubernetes/
- Cilium - это мощный сетевой плагин с открытым исходным кодом для Kubernetes, который использует технологию eBPF (extended Berkeley Packet Filter) для мониторинга и управления сетевым трафиком на уровне ядра операционной системы
    - Основное
        - Cilium https://client.sbertech.ru/docs/public/K8S/2.1.0/K8SC/1.5.0/documents/administration-guide/1-Cilium.html
        - В чем силиум, брат? Обзор ключевых фишек Cilium и его преимущества на фоне других CNI-проектов https://habr.com/ru/companies/kts/articles/825136/
        - Кратко про то, как кастомизировать сетевой стек в Kubernetes с Cilium https://habr.com/ru/companies/otus/articles/866796/
    - Hubble - это встроенный инструмент для мониторинга и наблюдения за сетевым трафиком в Cilium, предоставляющий расширенные возможности для анализа сетевого взаимодействия в кластерах Kubernetes
        - https://client.sbertech.ru/docs/public/K8S/2.1.0/K8SC/1.5.0/documents/administration-guide/1-Cilium-Hubble.html
    - Остальное
- etcd — это высоконадёжное и строго согласованное распределённое хранилище данных типа «ключ-значение» с открытым исходным кодом. Оно используется для хранения конфигураций и данных, необходимых для работы распределённых систем, таких как Kubernetes.
    - A Guide to etcd https://www.redhat.com/en/blog/a-guide-to-etcd
    - Как работает etcd с Kubernetes и без него https://habr.com/ru/companies/slurm/articles/803739/
- Остальное
    - Вертикальное масштабирование подов https://cloud.ru/docs/kubernetes-evolution/ug/topics/concepts__vertical-pod-autoscaler.html#id1