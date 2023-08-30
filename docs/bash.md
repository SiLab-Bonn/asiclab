# Bash set -e option, will cause shell to crash:

```
printf '%s\n' "$PROMPT_COMMAND"
__vte_prompt_command
```

```
__vte_prompt_command() { true; }
```

. "$HOME/.cargo/env"



# for the whole bash  vs tcsh problem:

ps -p $$ – Display your current shell name reliably. 

echo "$SHELL" – Print the shell for the current user but not necessarily the shell that is running at the movement. 

echo $0 – Another reliable and simple method to get the current shell interpreter name on Linux or Unix-like systems.


# Bash:

You can set env variables in a bash script by just writing X='text', where X is the env variable name. You don't have to export.

To make sure that these are available then in the terminal session that launched it, you need to make sure you source the script, or write a '.' before the bash script name. `.` is the POSIX compliant way of sourcing, and `source` is a Bash-exclusive synonym.


# Building specs table for each machine:

`lscpu` gives cpu info
`free -hm` gives ram info


# Find all files with certain extension:

`find . -type f -name "*.txt"`


# Find all files containing a certain string (you can add -i flag to IGNORE case)

`grep -R "text to find" .`

note, when running ls -l, the second column is the number of hardlinks (which is equal to the number of directories, sorta?) anyways, i can just think of it as the approximate number of directories inside this one.

### Using Git to restore a deleted, uncommitted file:
If your changes have not been staged or committed: The command you should use in this scenario is `git restore FILENAME`


## to figure out current tty number

`w`


## to show which tty are being used

```
ps -e | grep tty
```

to kill another tty
pkill -9 -t tty1

to show process numbers
ps -f

another tool which is useful for identifying and killing processes is top/htop.
i think that top can do everything htop can, but more easily
perhaps i should learn to play with top more in the future


who

whoami
whereis


```bash
for i in *.pdf
do
    mv "$i" "`echo $i | sed 's/ Circuit Intuitions//'`"
done
```

## Navigation

ls - list directory contents
pwd - print name of current/working directory
cd - change working directory
pushd/popd - put working directory on a stack
file - determine file type
find - file search by name, size, location, etc
locate - find files by name
updatedb - update database for locate
which - locate a command
history - display bash command history

#GETTING HELP

whatis - display the on-line manual descriptions
apropos - search the manual page names and descriptions
man - an interface to the on-line reference manuals

## WORKING W/ FILES

mkdir - create a directory/make directories
touch - change file timestamps/create empty files
cp - copy files and directories
mv - move (rename) files
rm - remove files or directories
rmdir - remove empty directories

## TEXT FILES

cat - concatenate files and print on the standard output
more/less - file perusal filter for crt viewing
nano - command line text editor

## USERS

sudo - execute a command as superuser
su - change user ID or become another user
users - print the user names of users currently logged in
id - print real and effective user and group IDs

## CHANGING FILE PERMISSIONS

chmod - change permissions of a file

## KILLING PROGRAMS AND LOGGING OUT

Ctrl+C - kill a running command
killall - kill processes by name
exit - log out of bash

## USEFUL SHORTCUTS

Ctrl+D - signal bash that there is no more input
Ctrl+L - redraw the screen
Ctrl++ - make text bigger in terminal emulator
Ctrl+- - make text smaller in terminal emulator

## MORE

pidof
top
ps acx
df
du
pgrep
gotop
htop
uname -a or -s -o
ip addr
ip address show
ip address
pinging website gives ip address
date
cal
df
du
grep
find
lsblk
dd
lspci
file
UTF-8 vs ASCII
cat
less
locate
updatedb
alias cp to `cp -iv`  (prompt before, and be verbose)
ldd


nohup (prevents shell exit from 'hang up' the processes aka killing the processes it started