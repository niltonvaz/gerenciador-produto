# 🚀 Guia de Setup - Gerenciador de Produtos

Passo-a-passo completo para clonar, configurar e acessar a aplicação no navegador.

---

## 📋 Pré-requisitos

Certifique-se que você tem instalado:

- ✅ **Git** (para clonar o repositório)
- ✅ **Docker** (para rodar os containers)
- ✅ **Docker Compose** (para orquestração)

**Verificar se estão instalados:**

```bash
git --version
docker --version
docker compose version
```

Se algum estiver faltando, instale:
- Linux: `sudo apt-get install docker.io docker-compose git`
- macOS: Use `brew install docker-compose git` (Docker Desktop já inclui tudo)
- Windows: Instale Docker Desktop

---

## 🔧 Passo 1: Clonar o Repositório

```bash
# Clone o repositório para sua máquina
git clone https://github.com/niltonrvazdev/gerenciador-produto.git

# Acesse a pasta do projeto
cd gerenciador-produto
```

**Resultado esperado:** Pasta `gerenciador-produto` com todos os arquivos.

---

## 🐳 Passo 2: Inicializar os Containers Docker

```bash
# Construir e iniciar os containers em background
docker compose up -d --build

# Aguarde 30-60 segundos para a aplicação inicializar completamente
sleep 30
```

**Resultado esperado:**
```
✔ Container laravel_mysql    Created
✔ Container laravel_app      Created
✔ Container laravel_nginx    Created
```

---

## ✅ Passo 3: Verificar se Tudo Funcionou

```bash
# Ver status dos containers (todos devem estar "Up")
docker compose ps

# Ver logs da aplicação (procure por "ready to handle connections")
docker compose logs app | tail -20

# Testar conexão HTTP
curl -s http://localhost:8000 | head -20
```

**Resultado esperado:**
- ✅ Todos os containers com status `Up`
- ✅ Logs mostrando: `NOTICE: ready to handle connections`
- ✅ curl retornando HTML (status 200 ou redirect)

---

## 🌐 Passo 4: Acessar no Navegador

Abra seu navegador e acesse:

```
http://localhost:8000
```

**Você deve ver:**
- ✅ Página inicial da aplicação Laravel
- ✅ Sem erros 502 Bad Gateway
- ✅ Aplicação completamente funcional

---

## 📝 Operações Comuns

### Parar a aplicação

```bash
docker compose down
```

### Reiniciar a aplicação (sem reconstruir)

```bash
docker compose restart
```

### Reconstruir e reiniciar (quando houver mudanças em Dockerfile)

```bash
docker compose down
docker compose up -d --build
```

### Ver logs em tempo real

```bash
# Todos os containers
docker compose logs -f

# Apenas a aplicação Laravel
docker compose logs -f app

# Apenas o Nginx
docker compose logs -f nginx

# Apenas o MySQL
docker compose logs -f db
```

### Acessar o container da aplicação (terminal)

```bash
docker compose exec app bash

# Dentro do container, você pode rodar:
php artisan tinker           # REPL do Laravel
composer install             # Instalar dependências PHP
npm install                  # Instalar dependências JavaScript
npm run build                # Compilar assets
```

---

## 🐛 Troubleshooting

### Erro 502 Bad Gateway

Se receber erro 502 ao acessar `http://localhost:8000`:

```bash
# 1. Verificar se containers estão rodando
docker compose ps

# 2. Verificar logs da aplicação
docker compose logs app

# 3. Se necessário, fazer validação automática
./validate_502_fix.sh

# 4. Se ainda falhar, consulte
cat TROUBLESHOOTING.md
cat DEBUG_CHECKLIST.md
```

### Porta 8000 já em uso

Se a porta 8000 estiver ocupada:

```bash
# Encontrar qual processo está usando a porta
lsof -i :8000
# ou
netstat -tulpn | grep 8000

# Matar o processo (substitua PID)
kill -9 PID

# Ou alterar a porta no docker-compose.yml:
# Mude "8000:80" para "8001:80" ou outra porta disponível
```

### MySQL não está respondendo

```bash
# Verificar se o container MySQL está saudável
docker compose logs db

# Reiniciar apenas o MySQL
docker compose restart db

# Se persistir, remover volumes (CUIDADO: apaga dados!)
docker compose down -v
docker compose up -d --build
```

### Assets não estão carregando (CSS/JS em branco)

```bash
# Dentro do container, recompilar assets
docker compose exec app npm run build

# Ou limpar cache do navegador (Ctrl+Shift+Del) e recarregar
```

---

## 📊 Estrutura do Projeto

```
gerenciador-produto/
├── app/                      # Código da aplicação Laravel
│   ├── Http/
│   ├── Models/
│   ├── Services/
│   └── View/
├── docker/                   # Configuração Docker
│   ├── php/
│   ├── nginx/
│   └── entrypoint.sh
├── database/                 # Migrations e seeders
├── resources/                # Views, CSS, JavaScript
├── routes/                   # Rotas da aplicação
├── storage/                  # Arquivos gerados
├── docker-compose.yml        # Orquestração dos containers
├── package.json              # Dependências JavaScript
├── composer.json             # Dependências PHP
└── TROUBLESHOOTING.md        # Documentação de problemas anteriores
```

---

## 🔐 Informações de Acesso

### Banco de Dados MySQL

```
Host: localhost (via docker: db)
Port: 3306
Database: laravel
Username: laravel
Password: laravel
Root Password: root
```

Para acessar via cliente MySQL:
```bash
mysql -h 127.0.0.1 -u laravel -p
# Senha: laravel
```

### Nginx

```
Host: localhost
Port: 8000
```

### PHP-FPM

```
Host: app (dentro de Docker)
Port: 9000 (apenas interno)
```

---

## 📚 Próximos Passos

1. **Explorar a aplicação:**
   - Visite http://localhost:8000
   - Teste as funcionalidades

2. **Consultar documentação técnica:**
   - [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Detalhes dos problemas resolvidos
   - [DEBUG_CHECKLIST.md](./DEBUG_CHECKLIST.md) - Checklist de diagnóstico
   - [CHANGELOG.md](./CHANGELOG.md) - Histórico de alterações

3. **Desenvolver:**
   - Editar arquivos em `resources/` para views
   - Editar `app/` para lógica da aplicação
   - Editar `routes/` para criar novas rotas

4. **Fazer build e deploy:**
   ```bash
   # Build para produção
   docker compose build --no-cache
   
   # Deploy (após testar localmente)
   docker compose up -d
   ```

---

## ✨ Dicas Úteis

### Auto-reload de assets (desenvolvimento)

Se quiser que CSS/JavaScript sejam recompilados automaticamente:

```bash
docker compose exec app npm run dev
```

(Isso inicia o Vite em modo watch — vai reconstruir quando arquivos mudarem)

### Limpar tudo e começar do zero

```bash
# Parar containers
docker compose down

# Remover volumes (CUIDADO: apaga dados!)
docker compose down -v

# Remover imagens
docker image rm gerenciador-produto-app

# Começar novamente
docker compose up -d --build
```

### Acessar logs persistentes

```bash
# Ver logs históricos
docker compose logs --tail=100 app

# Salvar logs em arquivo
docker compose logs > logs.txt
```

---

## 📞 Suporte

Se encontrar problemas:

1. Consulte [DEBUG_CHECKLIST.md](./DEBUG_CHECKLIST.md) para diagnóstico rápido
2. Verifique [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) para problemas conhecidos
3. Execute o script de validação:
   ```bash
   ./validate_502_fix.sh
   ```

---

**Data de criação:** 04/02/2026  
**Última atualização:** 04/02/2026  
**Status:** ✅ TESTADO E VALIDADO
