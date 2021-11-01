#!/bin/sh

# source: https://stackoverflow.com/questions/10408816/how-do-i-use-the-nohup-command-without-getting-nohup-out
nohup discord --start-minimized >/dev/null 2>&1 &
nohup slack -u >/dev/null 2>&1 &
nohup telegram-desktop -startintray >/dev/null 2>&1 &
# nohup upwork >/dev/null 2>&1 &
nohup teams --system-initiated >/dev/null 2>&1 &
