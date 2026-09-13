#!/usr/bin/env sh
printf "INFO: stowing root/home/\n" &&      stow -d ~/dotfiles/root/ -t /home/ home
printf "INFO: stowing root/etc/\n"  && sudo stow -d ~/dotfiles/root/ -t /etc/  etc
