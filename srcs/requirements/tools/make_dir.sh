#!/bin/bash/

if [ ! -d "/home/${USER}/data" ]; then
	mkdir	"/home/${USER}/data"
fi

if [ ! -d "/home/${USER}/data/mariadb" ]; then
        mkdir   "/home/${USER}/data/mariadb"
fi

if [ ! -d "/home/${USER}/data/wordpress" ]; then
        mkdir   "/home/${USER}/data/wordpress"
fi
