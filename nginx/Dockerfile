FROM nginx:alpine

# Instalar Certbot e dependências
RUN apk add --no-cache certbot bash openssl

# Criar diretórios necessários para Certbot
RUN mkdir -p /var/www/certbot /etc/letsencrypt/live /etc/letsencrypt/archive

# Copiar configuração do NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar script de renovação do Certbot
COPY certbot-renew.sh /usr/local/bin/certbot-renew.sh
RUN chmod +x /usr/local/bin/certbot-renew.sh
EXPOSE 80
# Comando de inicialização
CMD ["sh", "-c", "/usr/local/bin/certbot-renew.sh & nginx -g 'daemon off;'"]
