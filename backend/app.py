from flask import Flask, jsonify, request
import psycopg2
import os

app = Flask(__name__)

# Configurações do banco de dados
DB_HOST = os.getenv("DATABASE_HOST", "database")
DB_USER = os.getenv("DATABASE_USER", "admin")
DB_PASSWORD = os.getenv("DATABASE_PASSWORD", "adminpass")
DB_NAME = os.getenv("DATABASE_NAME", "mydb")

# Conectar ao banco de dados
def get_db_connection():
    conn = psycopg2.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        dbname=DB_NAME
    )
    return conn

# 🔹 Rota para buscar todos os usuários
@app.route('/api/users', methods=['GET'])
def get_users():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, nome FROM usuarios;")
    users = cursor.fetchall()
    conn.close()

    return jsonify([{"id": u[0], "nome": u[1]} for u in users])

# 🔹 Rota para adicionar um novo usuário
@app.route('/api/users', methods=['POST'])
def add_user():
    data = request.json
    if not data or "nome" not in data:
        return jsonify({"error": "Nome é obrigatório"}), 400

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO usuarios (nome) VALUES (%s) RETURNING id;", (data["nome"],))
    user_id = cursor.fetchone()[0]
    conn.commit()
    conn.close()

    return jsonify({"id": user_id, "nome": data["nome"]}), 201

if __name__ == '__main__':
    start_http_server(8000) 
    app.run(host="0.0.0.0", port=8000)
