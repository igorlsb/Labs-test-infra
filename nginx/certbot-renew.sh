#!/bin/bash

set -e

DOMINIOS=("frontend.dominiotest1.com")
EMAIL="igor.lsb@hotmail.com"
CERT_PATH="/etc/letsencrypt/live/${DOMINIOS[0]}/fullchain.pem"

mkdir -p /var/www/certbot
chmod -R 755 /var/www/certbot

if [ ! -f "$CERT_PATH" ]; then
    echo "Nenhum certificado encontrado. Gerando novo..."
    certbot certonly --webroot -w /var/www/certbot --email "$EMAIL" \
        --agree-tos --no-eff-email --force-renewal \
        $(for domain in "${DOMINIOS[@]}"; do echo -n " -d $domain"; done)
fi

# Criando cron job para renovar automaticamente
crontab -l | { cat; echo "0 */12 * * * certbot renew --quiet --post-hook 'nginx -s reload'"; } | crontab -