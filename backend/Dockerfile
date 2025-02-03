# Usa a imagem oficial do Python
FROM python:3.9

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .

# Expõe a porta e roda o servidor
EXPOSE 5000
CMD ["python", "app.py"]
