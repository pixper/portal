#!/bin/sh

while ! nc -z nginx 80; do
	sleep 0.1
done

CONF_DIR="/etc/nginx/conf.d"

mkdir -p "${CONF_DIR}/ssl"

for CERTBOT_DOMAIN in ${CERTBOT_DOMAINS//,/ }
do
    echo ${CERTBOT_DOMAIN}

    certbot certonly --webroot --webroot-path=/var/www/letsencrypt --email=$CERTBOT_EMAIL --agree-tos --no-eff-email -d $CERTBOT_DOMAIN --non-interactive --keep-until-expiring

    echo "ssl_certificate  /etc/letsencrypt/live/${CERTBOT_DOMAIN}/fullchain.pem;" > "/etc/nginx/conf.d/ssl/${CERTBOT_DOMAIN}.conf"
    echo "ssl_certificate_key  /etc/letsencrypt/live/${CERTBOT_DOMAIN}/privkey.pem;" >> "/etc/nginx/conf.d/ssl/${CERTBOT_DOMAIN}.conf"

    [ -f "${CONF_DIR}/${CERTBOT_DOMAIN}.conf.inactive" ] && mv "${CONF_DIR}/${CERTBOT_DOMAIN}.conf.inactive" "${CONF_DIR}/${CERTBOT_DOMAIN}.conf"
done

while :;
do
	certbot renew --quiet
	sleep 1d
done
