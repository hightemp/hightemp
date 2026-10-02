## Сделать stash всех файлов, включая untracked

```console
$ git stash --include-untracked
```

## Проверить, попал ли коммит в удалённую ветку

Обновите ссылки на удалённые ветки, затем проверьте, является ли коммит предком `origin/main`. Укажите вместо `HEAD` хеш коммита из `git log --oneline`, если нужно проверить конкретный коммит:

```bash
commit=HEAD
git fetch origin

if git merge-base --is-ancestor "$commit" origin/main; then
  echo "Коммит есть в origin/main"
else
  status=$?
  if [ "$status" -eq 1 ]; then
    echo "Коммита нет в origin/main"
  else
    echo "Не удалось проверить коммит" >&2
    exit "$status"
  fi
fi
```

`git merge-base --is-ancestor` проверяет достижимость именно этого коммита из `origin/main`: код возврата `0` означает «есть», `1` — «нет», другие коды — ошибку проверки. `git fetch origin` обновляет локальную ссылку `origin/main`, не меняя текущую ветку и рабочие файлы. Если remote называется иначе, подставьте его имя вместо `origin`.

После `cherry-pick` или `rebase` хеш коммита меняется; исходный коммит не считается достижимым, даже если его изменения перенесли.

### Другие способы

Показать удалённые ветки, в которых содержится конкретный коммит:

```bash
commit=HEAD # или хеш коммита
git fetch origin
git branch -r --contains "$commit"
```

Если среди результатов есть `origin/main`, коммит входит в историю этой ветки.

Показать коммиты текущей ветки, которых пока нет в `origin/main`:

```bash
git fetch origin
git log --oneline origin/main..HEAD
```

Нужный коммит в списке означает, что он ещё не достижим из `origin/main`.

Проверить, перенесены ли изменения коммитов в текущую ветку через `cherry-pick`:

```bash
git fetch origin
git cherry -v origin/main HEAD
```

Знак `-` означает, что эквивалентное изменение уже есть в `origin/main`; `+` означает, что Git не нашёл там такого изменения.

## alias

```
alias gcm='git commit -am'
```
