- https://superuser.com/questions/1200539/cannot-increase-open-file-limit-past-4096-ubuntu/1200818#1200818?s=1b927bb17396480da98a94cbacf8da62

I had to add the following line to /etc/systemd/user.conf:

DefaultLimitNOFILE=65535

As written in the answer here:

https://superuser.com/questions/1200539/cannot-increase-open-file-limit-past-4096-ubuntu/1200818#1200818?s=1b927bb17396480da98a94cbacf8da62

Also you may need to run this (if working with applications that monitors changes in many files/folders):

sudo sh -c 'sysctl fs.inotify.max_user_watches=524288 && sysctl -p'
