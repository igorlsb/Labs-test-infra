CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

INSERT INTO usuarios (nome) VALUES ('Igor'), ('Michele'), ('Charlie');
