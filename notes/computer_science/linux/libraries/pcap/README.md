# Pcap

**Pcap** (от англ. Packet Capture) — библиотека, служащая для создания программ анализа сетевых данных, поступающих на сетевую карту компьютера.

Примером программы, которая использует библиотеку Pcap, служит программа Wireshark. Разнообразные программы мониторинга и тестирования сети, снифферы используют эту библиотеку. Она предназначена для использования совместно с языками C/C++, а для работы с библиотекой на других языках, таких как Java, .NET, используют обёртки. Для Unix-подобных систем это библиотека libpcap, а для Microsoft Windows — WinPcap. Программное обеспечение сетевого мониторинга может использовать libpcap или WinPcap, чтобы захватить пакеты, путешествующие по сети, и (в более новых версиях) для передачи пакетов в сети. Libpcap и WinPcap также поддерживают сохранение захваченных пакетов в файл и чтение файлов, содержащих сохранённые пакеты. Программы, написанные на основе libpcap или WinPcap, могут захватить сетевой трафик, анализировать его. Файл захваченного трафика сохраняется в формате, понятном для приложений, использующих Pcap. 

https://ru.wikipedia.org/wiki/Pcap