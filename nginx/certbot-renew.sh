#!/bin/bash

set -e  # Interrompe o script em caso de erro

# Definições
DOMINIOS=("frontend.dominiotest1.com")
EMAIL="igor.lsb@hotmail.com"
CERT_PATH="/etc/letsencrypt/live/${DOMINIOS[0]}/fullchain.pem"

# Criando diretórios necessários e ajustando permissões
mkdir -p /var/www/certbot /etc/letsencrypt/live /etc/letsencrypt/archive /etc/letsencrypt/renewal
chmod -R 755 /var/www/certbot
chmod -R 755 /etc/letsencrypt
chown -R root:root /etc/letsencrypt

# Se o certificado não existir, gera um novo
if [ ! -f "$CERT_PATH" ]; then
    echo "Nenhum certificado encontrado. Gerando novo..."
    
    for domain in "${DOMINIOS[@]}"; do
        certbot certonly --webroot -w /var/www/certbot --email "$EMAIL" \
            --agree-tos --no-eff-email --force-renewal -d "$domain"
    done

    if [ $? -eq 0 ]; then
        echo "✅ Certificado gerado com sucesso!"
        systemctl restart nginx  # Reinicia o NGINX apenas se a geração for bem-sucedida
    else
        echo "❌ Erro ao gerar certificado SSL. Verifique as configurações."
        exit 1
    fi
else
    echo "✔ Certificado SSL já existe."
fi

# Criando cron job para renovação automática a cada 12 horas
if ! crontab -l | grep -q "certbot renew"; then
    (crontab -l 2>/dev/null; echo "0 */12 * * * certbot renew --quiet --post-hook 'nginx -s reload'") | crontab -
    echo "✅ Tarefa agendada no cron para renovação do certificado."
else
    echo "✔ Tarefa de renovação já está configurada no cron."
fi
