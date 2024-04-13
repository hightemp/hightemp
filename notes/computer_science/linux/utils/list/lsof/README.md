# lsof

## Описание

lsof - это команда, которая позволяет просматривать список открытых файлов на компьютере.

## Репозитории

- https://github.com/lsof-org/lsof
- https://github.com/lsof-org/lsof-linux

## Маны

- [[en] 4.90](./man/4.90/manpage.en.md)
- [[en] 4.99.3](./man/4.99.3/manpage.en.md)

## Пример

```
$ cat > /tmp/LOG &
cat > /tmp/LOG &
[1] 18083
$ lsof -p 18083
lsof -p 18083
COMMAND   PID   USER   FD   TYPE DEVICE  SIZE/OFF     NODE NAME
cat     18083 yamato  cwd    DIR   0,44      1580 43460784 /tmp/lsof
cat     18083 yamato  rtd    DIR  253,2      4096        2 /
cat     18083 yamato  txt    REG  253,2     47432   678364 /usr/bin/cat
cat     18083 yamato  mem    REG  253,2 111950656   681778 /usr/lib/locale/locale-archive
cat     18083 yamato  mem    REG  253,2   2119256   679775 /usr/lib64/libc-2.27.so
cat     18083 yamato  mem    REG  253,2    187632   655943 /usr/lib64/ld-2.27.so
cat     18083 yamato  mem    REG  253,2     26370   662532 /usr/lib64/gconv/gconv-modules.cache
cat     18083 yamato  mem    REG  253,2      3316  1578981 /usr/lib/locale/en_US.utf8/LC_TIME
cat     18083 yamato    0u   CHR  136,3       0t0        6 /dev/pts/3
cat     18083 yamato    1w   REG   0,44         0 54550934 /tmp/LOG
cat     18083 yamato    2u   CHR  136,3       0t0        6 /dev/pts/3
```

