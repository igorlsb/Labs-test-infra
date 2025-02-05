# Usa a imagem oficial do NGINX baseado no Alpine
FROM nginx:alpine

# Instalar OpenSSL e Bash para criar certificados autoassinados
RUN apk add --no-cache openssl bash

# Criar diretório para armazenar certificados SSL
RUN mkdir -p /etc/nginx/ssl \
    && chmod -R 755 /etc/nginx/ssl

# Gerar certificado SSL autoassinado dentro da imagem do contêiner para múltiplos subdomínios
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx-selfsigned.key \
    -out /etc/nginx/ssl/nginx-selfsigned.crt \
    -subj "/C=BR/ST=SP/L=SaoPaulo/O=LocalTest/CN=frontend.dominioteste.com" \
    -addext "subjectAltName=DNS:frontend.dominioteste.com,DNS:prometheus.dominioteste.com,DNS:grafana.dominioteste.com,DNS:loki.dominioteste.com"

# Criar parâmetros Diffie-Hellman para segurança extra
RUN openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048

# Copiar o arquivo de configuração do NGINX
COPY nginx.conf /etc/nginx/nginx.conf

# Comando de inicialização do NGINX
CMD ["nginx", "-g", "daemon off;"]
