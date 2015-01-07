# Gentoo HHVM scripts

This repository contains some useful scripts, meant to be used together with
[HHVM](https://github.com/facebook/hhvm) from
[our overlay](https://github.com/skyfms/portage-overlay) on Gentoo Linux.

Currently there are two scripts:
* `check_and_start_hhvm.sh` - checks that HHVM instance(s) are running and
if not, starts them.
* `restart_hhvm.sh` - HHVM restart script, with retry support.

Recommended practice is to add them to crontab and check for HHVM status each
minute and always restart HHVM periodically, because it is known that HHVM
currently is not optimized for a long runs (Facebook restarts all instances
multiple times per day).

Crontab example (for root user), assuming you have two instaces of HHVM,
called `hhvm.9000` and `hhvm.9001`, running on the same server:
```
0       7,19    *       *       *       /usr/sbin/restart_hhvm.sh 9000 1200 | grep -v "\[ ok \]"
0       8,20    *       *       *       /usr/sbin/restart_hhvm.sh 9001 1200 | grep -v "\[ ok \]"
*       *       *       *       *       /usr/sbin/check_and_start_hhvm.sh 9000
*       *       *       *       *       /usr/sbin/check_and_start_hhvm.sh 9001
```
