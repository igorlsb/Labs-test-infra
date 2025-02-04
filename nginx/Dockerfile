FROM nginx:alpine

# Criar diretórios necessários para Certbot
RUN mkdir -p /var/www/certbot /etc/letsencrypt/live /etc/letsencrypt/archive \
    && chmod -R 755 /var/www/certbot /etc/letsencrypt \
    && chown -R root:root /etc/letsencrypt

# Copiar configuração do NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar o script de entrada
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Comando de inicialização (aguarda certificados antes de iniciar)
CMD ["/usr/local/bin/entrypoint.sh"]
