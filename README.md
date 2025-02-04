# Infraestrutura DevOps com Docker, NGINX, Let's Encrypt e Monitoramento (Em andamento)

Este projeto implementa uma infraestrutura **escalável, segura e automatizada** para uma aplicação web, utilizando **Docker, NGINX (com HTTPS via Let's Encrypt), balanceamento de carga e monitoramento com Prometheus, Grafana e Loki**.

## Visão Geral do Projeto
A infraestrutura foi projetada para suportar um ambiente containerizado. Os principais componentes incluem:

- **Docker Compose** - Orquestração dos serviços  
- **NGINX** - Reverse Proxy, Load Balancer e Certificados SSL  
- **Let's Encrypt (Certbot)** - Certificados SSL automáticos  
- **Backend (3 Réplicas)** - Escalabilidade horizontal  
- **Frontend** - Servindo a aplicação ao usuário  
- **PostgreSQL** - Banco de dados persistente  
- **Monitoramento** - Stack de Prometheus + Grafana + Loki para logs e métricas  
- **Pipeline CI/CD** - Implementado, porém o roteador não permite completar o processo  

---

## Arquitetura da Infraestrutura
A infraestrutura está dividida nos seguintes serviços:

| Serviço        | Descrição |
|---------------|-----------|
| **Frontend**  | Interface da aplicação, servida via NGINX |
| **Backend**   | API principal (3 réplicas para escalabilidade) |
| **NGINX**     | Reverse Proxy e Balanceador de Carga com SSL |
| **Certbot**   | Automatiza a renovação dos certificados SSL |
| **PostgreSQL**| Banco de Dados Relacional |
| **Prometheus**| Coleta métricas do sistema |
| **Grafana**   | Dashboard para visualizar métricas |
| **Loki**      | Centralização de logs |

---

## Pré-requisitos
Antes de rodar o projeto, instale os seguintes pacotes:

- **Docker** (https://docs.docker.com/get-docker/)
- **Docker Compose** (https://docs.docker.com/compose/install/)

---

## Como Rodar o Projeto
### 1. Clonar o repositório
```bash
git clone https://github.com/igorlsb/Labs-test-infra.git
cd Labs-test-infra
```

### 2. Configurar Variáveis de Ambiente
Crie um arquivo `.env` na raiz do projeto e adicione:

```env
POSTGRES_USER=admin
POSTGRES_PASSWORD=securepassword
```

### 3. Gerar os Certificados SSL (Let's Encrypt)
Antes de rodar a aplicação, garanta que os certificados SSL foram gerados corretamente:

```bash
docker-compose run --rm certbot certonly --webroot -w /var/www/certbot --email seu-email@dominio.com \
    -d frontend.dominiotest1.com -d grafana.dominiotest1.com \
    -d loki.dominiotest1.com -d prometheus.dominiotest1.com --agree-tos --no-eff-email --force-renewal
```

Isso criará os certificados SSL na pasta **`./certbot/conf`**.

### 4. Subir a Infraestrutura
Agora, basta rodar:

```bash
docker-compose up -d
```

---

## Acessando a Aplicação
Após iniciar os serviços, acesse:

| Serviço        | URL |
|---------------|-----------|
| **Frontend**  | `https://frontend.dominiotest1.com` |
| **Backend**   | `https://backend.dominiotest1.com` |
| **Monitoramento (Grafana)** | `https://grafana.dominiotest1.com` |
| **Logs (Loki)** | `https://loki.dominiotest1.com` |
| **Métricas (Prometheus)** | `https://prometheus.dominiotest1.com` |


---

## Monitoramento
A infraestrutura conta com monitoramento via **Prometheus, Grafana e Loki**:

- **Prometheus** coleta métricas dos serviços
- **Grafana** exibe dashboards para análise de desempenho
- **Loki** centraliza logs dos contêineres para troubleshooting

Para acessar os dashboards, vá para **`https://grafana.dominiotest1.com`** e use:

**Usuário:** `admin`  
**Senha:** `admin` (ou altere no arquivo `docker-compose.yml`)

---

## Pipeline CI/CD
O pipeline de integração e entrega contínua (CI/CD) foi implementado, mas o roteador não permite completar o processo para retorno e subir ao servidor local. Para utilizar o CI/CD corretamente, é necessário liberar as portas corretas no roteador e permitir conexões externas ao servidor de build.

---
