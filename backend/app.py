from flask import Flask, jsonify, request
import psycopg2
import os
import logging
from contextlib import closing
from prometheus_client import generate_latest, Counter, Histogram
from prometheus_client import CollectorRegistry, CONTENT_TYPE_LATEST

# Configuração de logs
logging.basicConfig(level=logging.INFO)

app = Flask(__name__)

# Configurações do banco de dados
DB_HOST = os.getenv("DATABASE_HOST", "database")
DB_USER = os.getenv("DATABASE_USER", "admin")
DB_PASSWORD = os.getenv("DATABASE_PASSWORD", "adminpass")
DB_NAME = os.getenv("DATABASE_NAME", "mydb")

# Definição de métricas do Prometheus
REQUEST_COUNT = Counter('http_requests_total', 'Total de requisições recebidas', ['method', 'endpoint'])
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'Duração das requisições', ['endpoint'])

# Função para obter a conexão com o banco
def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            dbname=DB_NAME
        )
        return conn
    except Exception as e:
        logging.error(f"Erro ao conectar ao banco de dados: {e}")
        return None

# Rota para buscar todos os usuários
@app.route('/api/users', methods=['GET'])
def get_users():
    REQUEST_COUNT.labels(method='GET', endpoint='/api/users').inc()
    with REQUEST_LATENCY.labels(endpoint='/api/users').time():
        conn = get_db_connection()
        if not conn:
            return jsonify({"error": "Erro ao conectar ao banco de dados"}), 500

        with closing(conn.cursor()) as cursor:
            cursor.execute("SELECT id, nome FROM usuarios;")
            users = cursor.fetchall()

        conn.close()
        return jsonify([{"id": u[0], "nome": u[1]} for u in users])

# Rota para adicionar um novo usuário
@app.route('/api/users', methods=['POST'])
def add_user():
    REQUEST_COUNT.labels(method='POST', endpoint='/api/users').inc()
    with REQUEST_LATENCY.labels(endpoint='/api/users').time():
        data = request.json
        if not data or "nome" not in data:
            return jsonify({"error": "Nome é obrigatório"}), 400

        conn = get_db_connection()
        if not conn:
            return jsonify({"error": "Erro ao conectar ao banco de dados"}), 500

        try:
            with closing(conn.cursor()) as cursor:
                cursor.execute("INSERT INTO usuarios (nome) VALUES (%s) RETURNING id;", (data["nome"],))
                user_id = cursor.fetchone()[0]
                conn.commit()
        except Exception as e:
            logging.error(f"Erro ao inserir usuário: {e}")
            return jsonify({"error": "Erro ao salvar usuário"}), 500
        finally:
            conn.close()

        return jsonify({"id": user_id, "nome": data["nome"]}), 201

# Endpoint de métricas do Prometheus
@app.route('/metrics', methods=['GET'])
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

# Endpoint de status para health check
@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "ok"}), 200

# Iniciar servidor
if __name__ == '__main__':
    logging.info("Backend rodando na porta 8000")
    app.run(host="0.0.0.0", port=8000)
