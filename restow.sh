#!/usr/bin/env sh
if ! sudo -v; then
    printf "\x1b[1;31mERR:\x1b[0m sudo authentication failed, aborting\n"
    exit 1
fi
# /home
printf "\x1b[1;34mINFO:\x1b[0m REstowing root/home\n" &&
    stow -R -d ~/dotfiles/root/ -t /home/ home &&
    printf "\x1b[1;32mINFO:\x1b[0m done REstowing root/home\n" ||
    printf "\x1b[1;31mERR:\x1b[0m could not REstow root/home\n"
# /etc
printf "\x1b[1;34mINFO:\x1b[0m REstowing root/etc\n" &&
    sudo stow -R -d ~/dotfiles/root/ -t /etc/ etc &&
    printf "\x1b[1;32mINFO:\x1b[0m done REstowing root/etc\n" ||
    printf "\x1b[1;31mERR:\x1b[0m could not REstow root/etc\n"
