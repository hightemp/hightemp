# groff

## Описание

Groff (GNU troff) - это система форматирования документов, которая является свободной реализацией и расширением системы troff из операционной системы Unix компании AT&T. Groff предоставляет набор программ и утилит для верстки текстовых документов, таких как руководства (man-страницы), статьи и книги.

## Репозитории

- https://git.savannah.gnu.org/git/groff.git

## Примеры

Примеры использования утилиты groff:

1. Вывод "Hello, world!" в терминал с кодировкой ASCII:
   ```
   $ echo "Hello, world!" | groff -Tascii | sed '/^$/d'
   ```

2. Вывод "Hello, world!" в терминал с кодировкой UTF-8:
   ```
   $ echo "Hello, world!" | groff -Tutf8 | sed '/^$/d'
   ```

3. Создание PDF-файла с текстом "Hello, world!":
   ```
   $ echo "Hello, world!" | groff -Tpdf > hello.pdf
   $ evince hello.pdf
   ```

4. Создание HTML-файла с текстом "Hello, world!":
   ```
   $ echo "Hello, world!" | groff -Thtml > hello.html
   $ firefox hello.html
   ```

5. Создание DVI-файла с текстом "Hello, world!":
   ```
   $ echo "Hello, world!" | groff -Tdvi > hello.dvi
   $ xdvi hello.dvi
   ```

6. Использование groff в режиме REPL (read-evaluate-print loop):
   ```
   $ groff -ww -Tutf8
   \# This is a comment. Let's define a register.
   .nr a 1
   \# Do integer arithmetic with operators evaluated left-to-right.
   .nr b \n[a]+5/2
   \# Let's get the result on the standard error stream.
   .tm \n[b]
   3
   \# Now we'll define a string.
   .ds name Leslie\" This is another form of comment.
   .nr b (\n[a] + (7/2))
   \# Center the next two text input lines.
   .ce 2
   Hi, \*[name].
   Your secret number is \n[b].
   \# We will see that the division rounded toward zero.
   It is
   \# Here's an if-else control structure.
   .ie (\n[b] % 2) odd.
   .el even.
   \# This trick sets the page length to the current vertical
   \# position, so that blank lines don't spew when we're done.
   .pl \n[nl]u
   <Control-D>
                                  Hi, Leslie.
                           Your secret number is 4.
       It is even.
   ```

## Документация

- https://man7.org/linux/man-pages/man1/groff.1.html

## Сайт

- https://www.gnu.org/software/groff/
