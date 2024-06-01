### PHP: how to start a detached process?

If you have the pcntl extension installed, it would be:

```php
function detached_exec($cmd) {
    $pid = pcntl_fork();
    switch($pid) {
         // fork errror
         case -1 : return false;

         // this code runs in child process
         case 0 :
             // obtain a new process group
             posix_setsid();
             // exec the command
             exec($cmd);
             break;

         // return the child pid in father
         default: 
             return $pid;
    }
}
```

Call it like this:

```php
$pid = detached_exec($cmd);
if($pid === FALSE) {
    echo 'exec failed';
}

// ... do some work ...

// Optionally, kill child process (if no longer required).
posix_kill($pid, SIGINT);
waitpid($pid, $status);

echo 'Child exited with ' . $status;
```

### Папка composer в системе

```
/home/user/.config/composer
/home/user/.config/composer/vendor/bin/
```

### Последний день месяца

#### Вариант 1

For example, on a 32-bit system, this code will echo 1970-01-31:

```php
$a_date = "2040-11-23";
echo date("Y-m-t", strtotime($a_date));
```

If you need your code to support 32-bit systems, then you should instead use the DateTime function:

```php
$d = new DateTime('2040-11-23'); 
echo $d->format('Y-m-t');
```

#### Вариант 2

```php
$month_start = strtotime('first day of this month', time());
$month_end = strtotime('last day of this month', time());

$year_start = strtotime('first day of January', time());
$year_end = strtotime('last day of December', time());
```

```php
$date = new DateTime('now');
$date->modify('last day of this month');
echo $date->format('Y-m-d');
```

