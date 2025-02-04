FROM nginx:alpine

# Instalando Certbot dentro do container
RUN apk add --no-cache certbot bash openssl

# Criando diretórios necessários para Certbot
RUN mkdir -p /var/www/certbot /etc/letsencrypt/live /etc/letsencrypt/archive

# Copiando configuração do NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Copiando script de renovação automática do Certbot
COPY certbot-renew.sh /usr/local/bin/certbot-renew.sh
RUN chmod +x /usr/local/bin/certbot-renew.sh

# Comando de inicialização
CMD ["sh", "-c", "/usr/local/bin/certbot-renew.sh & nginx -g 'daemon off;'"]
