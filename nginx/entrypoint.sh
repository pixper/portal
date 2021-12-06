#!/bin/sh

nginx

old_checksum=$(cat /etc/nginx/conf.d/*.conf /etc/letsencrypt/live/*/*.pem | sha1sum | awk '{print $1}')
inotifywait -e modify,move,create,delete -mr /etc/nginx/conf.d/ | while read file
do
	new_checksum=$(cat /etc/nginx/conf.d/*.conf /etc/letsencrypt/live/*/*.pem | sha1sum | awk '{print $1}')
	if [ "$new_checksum" != "$old_checksum" ]; then
		echo "Detected change: ${old_checksum} -> ${new_checksum}"
		old_checksum=$new_checksum
		nginx -s reload
	fi
done
