#!/usr/bin/env sh
printf "INFO: UNstowing root/home/\n" &&      stow -D -d ~/dotfiles/root/ -t /home/ home
printf "INFO: UNstowing root/etc/\n"  && sudo stow -D -d ~/dotfiles/root/ -t /etc/  etc
