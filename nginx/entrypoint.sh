#!/bin/bash

echo "🔍 Verificando se os certificados SSL já existem..."

# Espera até que o Certbot gere os certificados
while [ ! -f /etc/letsencrypt/live/frontend.dominiotest1.com/fullchain.pem ]; do
    echo "⏳ Aguardando certificados SSL... (verificando a cada 5s)"
    sleep 10
done

echo "✅ Certificado encontrado! Iniciando NGINX..."
nginx -g "daemon off;"
