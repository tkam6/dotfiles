#!/usr/bin/env sh
if ! sudo -v; then
    printf "\x1b[1;31mERR:\x1b[0m sudo authentication failed, aborting\n"
    exit 1
fi
# /home
printf "\x1b[1;34mINFO:\x1b[0m UNstowing root/home\n" &&
    stow -D -d ~/dotfiles/root/ -t /home/ home &&
    printf "\x1b[1;32mINFO:\x1b[0m done UNstowing root/home\n" ||
    printf "\x1b[1;31mERR:\x1b[0m could not UNstow root/home\n"
# /etc
printf "\x1b[1;34mINFO:\x1b[0m UNstowing root/etc\n" &&
    sudo stow -D -d ~/dotfiles/root/ -t /etc/ etc &&
    printf "\x1b[1;32mINFO:\x1b[0m done UNstowing root/etc\n" ||
    printf "\x1b[1;31mERR:\x1b[0m could not UNstow root/etc\n"
