FROM hub.docker.internal.cba/archlinux:latest

COPY tree/ /

RUN pacman -Syu --noconfirm \
        arch-install-scripts \
        linux
