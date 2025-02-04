#!/bin/bash

# Primeiro, verifica se há um certificado válido, senão gera um novo
if [ ! -f "/etc/letsencrypt/live/seudominio.com/fullchain.pem" ]; then
    echo "Gerando certificado SSL..."
    certbot certonly --webroot -w /var/www/certbot --email igor.lsb@hotmail.com \
        -d dominiotest1.com -d www.dominiotest1.com --agree-tos --no-eff-email --force-renewal
fi

# Loop infinito para renovar certificados automaticamente a cada 12 horas
while true; do
    sleep 12h
    echo "Renovando certificado SSL..."
    certbot renew --quiet
    nginx -s reload  # Recarrega o NGINX após renovação
done
