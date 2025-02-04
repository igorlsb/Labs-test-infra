#!/bin/bash

# Definir variáveis
DOMAIN="dominioteste.com"
WEBROOT="/var/www/certbot"
CERT_PATH="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"

# Criar diretórios necessários para o Certbot e garantir as permissões
mkdir -p "$WEBROOT" "/etc/letsencrypt/live" "/etc/letsencrypt/archive"

# Garantir permissões corretas para evitar erro de acesso
chmod -R 755 "$WEBROOT" "/etc/letsencrypt"
chown -R www-data:www-data "$WEBROOT"
chown -R root:root "/etc/letsencrypt"

# Verifica se os certificados já existem
if [ ! -f "$CERT_PATH" ]; then
    echo "🔹 Nenhum certificado SSL encontrado. Gerando um novo..."
    
    certbot certonly --webroot -w "$WEBROOT" --email igor.lsb@hotmail.com \
        --agree-tos --no-eff-email --force-renewal -d "$DOMAIN"

    if [ $? -eq 0 ]; then
        echo "✅ Certificado gerado com sucesso!"
    else
        echo "❌ Erro ao gerar certificado SSL. Verifique as configurações."
        exit 1
    fi
else
    echo "✔ Certificado SSL já existe."
fi

# Adicionar renovação automática dos certificados no cron (sem duplicação)
(crontab -l | grep -v "certbot renew" ; echo "0 */12 * * * certbot renew --quiet --post-hook 'systemctl restart nginx'") | crontab -

echo "✅ Configuração finalizada! Certificados gerenciados automaticamente. 🚀"

echo "🔄 Inicializando NGINX..."
exec nginx -g "daemon off;"
