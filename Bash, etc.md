
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

## 
note, when running ls -l, the second column is the number of hardlinks (which is equal to the number of directories, sorta?) anyways, i can just think of it as the approximate number of directories inside this one.

### Using Git to restore a deleted, uncommitted file:
If your changes have not been staged or committed: The command you should use in this scenario is `git restore FILENAME`


## to figure out current tty number
w


## to show which tty are being used
ps -e | grep tty


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
