#!/bin/bash

# Criar diretórios necessários para o Certbot
mkdir -p /var/www/certbot /etc/letsencrypt/live /etc/letsencrypt/archive

# Permissões corretas para evitar erro de acesso
chmod -R 755 /var/www/certbot /etc/letsencrypt
chown -R root:root /etc/letsencrypt

# Verifica se os certificados existem
CERT_PATH="/etc/letsencrypt/live/frontend.dominiotest1.com/fullchain.pem"

if [ ! -f "$CERT_PATH" ]; then
    echo "🔹 Nenhum certificado SSL encontrado. Gerando um novo..."
    
    certbot certonly --webroot -w /var/www/certbot --email igor.lsb@hotmail.com \
        --agree-tos --no-eff-email --force-renewal -d frontend.dominiotest1.com

    if [ $? -eq 0 ]; then
        echo "✅ Certificado gerado com sucesso!"
    else
        echo "❌ Erro ao gerar certificado SSL. Verifique as configurações."
        exit 1
    fi
else
    echo "✔ Certificado SSL já existe."
fi

# Iniciar renovação automática dos certificados a cada 12 horas
(crontab -l 2>/dev/null; echo "0 */12 * * * certbot renew --quiet --post-hook 'nginx -s reload'") | crontab -

echo "🔄 Inicializando NGINX..."
exec nginx -g "daemon off;"
