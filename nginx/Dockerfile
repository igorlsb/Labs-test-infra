FROM nginx:alpine

# Instalar Certbot e dependências necessárias
RUN apk add --no-cache certbot bash openssl

# Criar diretórios necessários para o Certbot
RUN mkdir -p /var/www/certbot /etc/letsencrypt/live /etc/letsencrypt/archive \
    && chmod -R 755 /var/www/certbot /etc/letsencrypt \
    && chown -R root:root /etc/letsencrypt

# Copiar configuração do NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar script de renovação do Certbot
COPY certbot-renew.sh /usr/local/bin/certbot-renew.sh
RUN chmod +x /usr/local/bin/certbot-renew.sh

# Comando de inicialização: só inicia o NGINX se o script rodar corretamente
CMD ["sh", "-c", "/usr/local/bin/certbot-renew.sh && nginx -g 'daemon off;'"]
