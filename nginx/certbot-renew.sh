#!/bin/bash

# Lista de domínios
DOMINIOS="backend.dominiotest1.com frontend.dominiotest1.com prometheus.dominiotest1.com grafana.dominiotest1.com loki.dominiotest1.com"
EMAIL="igor.lsb@hotmail.com"

# Diretório onde os certificados são armazenados
CERT_PATH="/etc/letsencrypt/live/backend.dominiotest1.com/fullchain.pem"

# Verifica se já existe um certificado válido, senão gera um novo
if [ ! -f "$CERT_PATH" ]; then
    echo "🔹 Nenhum certificado SSL encontrado. Gerando um novo..."
    certbot certonly --webroot -w /var/www/certbot --email "$EMAIL" \
        --agree-tos --no-eff-email --force-renewal \
        $(for domain in $DOMINIOS; do echo -n " -d $domain"; done)
    
    echo "✅ Certificado gerado com sucesso!"
else
    echo "✔ Certificado SSL já existe."
fi

# Loop infinito para renovação automática a cada 12 horas
while true; do
    sleep 12h
    echo "🔄 Renovando certificado SSL..."
    
    certbot renew --quiet --post-hook "nginx -s reload"
    
    echo "✅ Certificado SSL renovado e NGINX recarregado!"
done
#!/bin/bash

# Lista de domínios
DOMINIOS="backend.dominiotest1.com frontend.dominiotest1.com prometheus.dominiotest1.com grafana.dominiotest1.com loki.dominiotest1.com"
EMAIL="igor.lsb@hotmail.com"

# Diretório onde os certificados são armazenados
CERT_PATH="/etc/letsencrypt/live/backend.dominiotest1.com/fullchain.pem"

# Verifica se já existe um certificado válido, senão gera um novo
if [ ! -f "$CERT_PATH" ]; then
    echo "🔹 Nenhum certificado SSL encontrado. Gerando um novo..."
    certbot certonly --webroot -w /var/www/certbot --email "$EMAIL" \
        --agree-tos --no-eff-email --force-renewal \
        $(for domain in $DOMINIOS; do echo -n " -d $domain"; done)
    
    echo "✅ Certificado gerado com sucesso!"
else
    echo "✔ Certificado SSL já existe."
fi

# Loop infinito para renovação automática a cada 12 horas
while true; do
    sleep 12h
    echo "🔄 Renovando certificado SSL..."
    
    certbot renew --quiet --post-hook "nginx -s reload"
    
    echo "✅ Certificado SSL renovado e NGINX recarregado!"
done
