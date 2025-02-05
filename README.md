## Infraestrutura DevOps com Docker, NGINX, Certificado Local e Monitoramento (Em andamento)

Este projeto implementa uma infraestrutura escalável, segura e automatizada para uma aplicação web, utilizando **Docker, NGINX (com HTTPS via certificado local), balanceamento de carga e monitoramento com Prometheus, Grafana e Loki**.

---
## **Arquitetura Proposta**
A infraestrutura foi projetada para suportar um ambiente containerizado, garantindo escalabilidade, segurança e automação. Os principais componentes incluem:

**Docker Compose** - Orquestração dos serviços  
**NGINX** - Reverse Proxy, Load Balancer e Certificados SSL  
**Certificado Local** - Implementado manualmente para conexões seguras  
**Backend (3 Réplicas)** - Escalabilidade horizontal  
**Frontend** - Servindo a aplicação ao usuário  
**PostgreSQL** - Banco de dados persistente  
**Monitoramento** - Stack de Prometheus + Grafana + Loki para logs e métricas  
**Portainer** - Gerenciamento de containers para melhor visualização  
**Pipeline CI/CD** - Implementado, porém o roteador não permite completar o processo  

A infraestrutura está dividida nos seguintes serviços:

| Serviço       | Descrição |
|--------------|------------|
| **Frontend**  | Interface da aplicação, servida via NGINX |
| **Backend**   | API principal (3 réplicas para escalabilidade) |
| **NGINX**     | Reverse Proxy e Balanceador de Carga com SSL |
| **Certificado Local**   | Implementação de certificado autoassinado para HTTPS |
| **PostgreSQL**| Banco de Dados Relacional |
| **Prometheus**| Coleta métricas do sistema |
| **Grafana**   | Dashboard para visualizar métricas |
| **Loki**      | Centralização de logs |
| **Portainer** | Interface de gerenciamento de containers |

---
## **Como Executar o Projeto**
### **1. Clonar o repositório**
```bash
git clone https://github.com/igorlsb/Labs-test-infra.git
cd Labs-test-infra
```

### **2. Configurar Variáveis de Ambiente**
Crie um arquivo `.env` na raiz do projeto e adicione:
```env
POSTGRES_USER=admin
POSTGRES_PASSWORD=securepassword
```

### **3. Configuração do Hosts no Windows**
Adicione a seguinte entrada ao arquivo `C:\Windows\System32\drivers\etc\hosts` para que o domínio local funcione corretamente:
```
192.168.3.21(Seu ip local do servidor) frontend.dominioteste.com
192.168.3.21(Seu ip local do servidor) prometheus.dominioteste.com
192.168.3.21(Seu ip local do servidor) grafana.dominioteste.com
192.168.3.21(Seu ip local do servidor) loki.dominioteste.com
```

### **4. Gerar os Certificados SSL (Certificado Local)**
Antes de rodar a aplicação, garanta que os certificados SSL foram gerados corretamente:
```bash
mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx-selfsigned.key \
    -out /etc/nginx/ssl/nginx-selfsigned.crt \
    -subj "/C=BR/ST=SP/L=SaoPaulo/O=LocalTest/CN=frontend.dominioteste.com" \
    -addext "subjectAltName=DNS:frontend.dominioteste.com,DNS:prometheus.dominioteste.com,DNS:grafana.dominioteste.com,DNS:loki.dominioteste.com"

openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
```
Isso criará os certificados SSL na pasta **`./certs`**.

### **5. Subir a Infraestrutura**
Agora, basta rodar:
```bash
docker-compose up -d
```
Todos os serviços serão iniciados em **modo desacoplado (-d)**.

---
## **Monitoramento**
A infraestrutura conta com monitoramento via **Prometheus, Grafana e Loki**:

**Prometheus** coleta métricas dos serviços  
**Grafana** exibe dashboards para análise de desempenho  
**Loki** centraliza logs dos contêineres para troubleshooting  

Prometheus acessível via https://prometheus.dominioteste.com  
Grafana acessível via https://grafana.dominioteste.com  
Loki acessível via https://loki.dominioteste.com  
Frontend acessível via https://frontend.dominioteste.com  

- **Usuário:** `admin`
- **Senha:** `admin` (ou altere no arquivo `docker-compose.yml`)

---
## **Pipeline CI/CD**
O pipeline de integração e entrega contínua (**CI/CD**) foi implementado, mas **o roteador não permite completar o processo para retorno e subir ao servidor local**.

Essa limitação ocorre porque a maioria dos roteadores domésticos e corporativos não permite a configuração direta de NAT Loopback, uma funcionalidade que possibilita acessar um serviço interno utilizando o próprio IP público. Sem essa configuração, as requisições externas que tentam retornar ao servidor local podem ser bloqueadas ou roteadas incorretamente. Além disso, alguns provedores de internet também restringem o redirecionamento de portas, impedindo que o tráfego retorne ao ambiente de CI/CD local sem configurações avançadas, como túneis VPN ou proxies reversos expostos à internet.

**Para utilizar o CI/CD corretamente:**
- **Libere as portas corretas no roteador**.
- **Permita conexões externas ao servidor de build**.
- **Configure corretamente os acessos do GitHub Actions ao ambiente local**.

### **Adicionar Secrets no GitHub**
Na seção **Settings > Secrets and Variables > Actions**, adicione os seguintes secrets:

- `DOCKER_HUB_USERNAME` → Nome de usuário do Docker Hub.
- `DOCKER_HUB_PASSWORD` → Senha do Docker Hub.
- `SERVER_HOST` → IP ou hostname do servidor onde o deploy será realizado.
- `SERVER_USER` → Usuário SSH para conexão ao servidor.
- `SSH_PRIVATE_KEY` → Chave privada SSH para acessar o servidor.

Esses valores serão usados para autenticação e deploy.

---
## **Decisões Técnicas e Justificativas**
1. **Uso de Docker e Docker Compose:** Facilita a orquestração e escalabilidade dos serviços, garantindo a padronização do ambiente de desenvolvimento e produção.  
2. **NGINX como Load Balancer:** Escolhido por sua leveza e eficiência no gerenciamento de tráfego entre múltiplas réplicas do backend.  
3. **Certificado Local para SSL:** Implementado para garantir conexões seguras sem depender de serviços externos como Let's Encrypt. O certificado foi gerado localmente apenas para demonstração, pois o Let's Encrypt exige o registro de um domínio.  
4. **Prometheus, Grafana e Loki para Monitoramento:** Permitem coleta de métricas detalhadas e análise de logs, garantindo visibilidade sobre a infraestrutura.  
5. **Portainer para Gerenciamento de Containers:** Utilizado para facilitar a administração e visualização dos containers em execução.  
6. **Pipeline CI/CD:** Implementado para automação do build, testes e deploy, mas com limitações devido à configuração do roteador.  

---
