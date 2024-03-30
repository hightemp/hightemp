
```bash
#!/bin/bash

# Остановка службы 3proxy, если она запущена
if [ -x /usr/bin/systemctl ]; then
    /usr/bin/systemctl stop 3proxy.service
elif [ -x /usr/sbin/service ]; then
    /usr/sbin/service 3proxy stop || true
fi

# Удаление установленных файлов и папок
rm -rf /usr/local/3proxy
rm -rf /etc/3proxy

# Удаление init-скриптов (если нужно)
if [ -x /usr/bin/update-rc.d ]; then
    /usr/bin/update-rc.d -f 3proxy remove
elif [ -x /usr/sbin/chkconfig ]; then
    /usr/sbin/chkconfig 3proxy off
fi

# Удаление systemd скрипта (если нужно и используется systemd)
rm /usr/lib/systemd/system/3proxy.service

echo ""
echo "3proxy и все связанные файлы и папки успешно удалены."
```