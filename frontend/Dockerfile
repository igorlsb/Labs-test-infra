# Usa a imagem do Nginx
FROM nginx:alpine

# Copia os arquivos HTML para o servidor web
COPY index.html /usr/share/nginx/html/index.html

# Expõe a porta do Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
