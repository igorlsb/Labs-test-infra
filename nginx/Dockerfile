FROM nginx:alpine

# Instalar Certbot e dependências
RUN apk add --no-cache certbot bash openssl

# Criar diretórios necessários para o Certbot
RUN mkdir -p /var/www/certbot /etc/letsencrypt/live /etc/letsencrypt/archive \
    && chmod -R 755 /var/www/certbot /etc/letsencrypt \
    && chown -R root:root /etc/letsencrypt

# Copiar configuração do NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar script de inicialização
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Copiar script de inicialização
RUN docker run --rm -it \
-v /etc/letsencrypt:/etc/letsencrypt \
-v /var/lib/letsencrypt:/var/lib/letsencrypt \
certbot/certbot certonly --manual --preferred-challenges dns \
--email igor.lsb@hotmail.com -d frontend.dominiotest1.com --agree-tos --no-eff-email --force-renewal

# Comando de inicialização
CMD ["/usr/local/bin/entrypoint.sh"]
