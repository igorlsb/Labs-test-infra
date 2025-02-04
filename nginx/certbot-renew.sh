#!/bin/bash

# Habilita modo estrito para interromper a execução em caso de erro
set -e

# Lista de domínios a serem protegidos com SSL
DOMINIOS=("frontend.dominiotest1.com")
EMAIL="igor.lsb@hotmail.com"

# Diretório onde os certificados são armazenados
CERT_PATH="/etc/letsencrypt/live/${DOMINIOS[0]}/fullchain.pem"

# Garante que o diretório do Certbot existe
mkdir -p /var/www/certbot
chmod -R 755 /var/www/certbot

# Verifica se já existe um certificado válido, senão gera um novo
if [ ! -f "$CERT_PATH" ]; then
    echo "Nenhum certificado SSL encontrado. Gerando um novo..."

    certbot certonly --webroot -w /var/www/certbot --email "$EMAIL" \
        --agree-tos --no-eff-email --force-renewal \
        $(for domain in "${DOMINIOS[@]}"; do echo -n " -d $domain"; done)

    if [ $? -eq 0 ]; then
        echo "✅ Certificado gerado com sucesso!"
    else
        echo "❌ Erro ao gerar certificado SSL. Verifique as configurações."
        exit 1
    fi
else
    echo "✔ Certificado SSL já existe."
fi

# Loop infinito para renovação automática a cada 12 horas
while true; do
    sleep 12h
    echo "🔄 Tentando renovar certificado SSL..."
    
    certbot renew --quiet --post-hook "nginx -s reload"

    if [ $? -eq 0 ]; then
        echo "✅ Certificado SSL renovado e NGINX recarregado!"
    else
        echo "❌ Erro ao renovar certificado SSL. Verifique os logs."
    fi
done
