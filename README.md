# 📦 Gerenciador de Produtos - Laravel 12 & Docker

Sistema de gerenciamento de produtos com **Laravel 12**, **PHP 8.3**, **Nginx**, **MySQL** e **Vite**.

---

## ⚡ Quick Start (3 Passos)

### 1️⃣ Clonar o Repositório
```bash
git clone https://github.com/niltonrvazdev/gerenciador-produto.git
cd gerenciador-produto
```

### 2️⃣ Iniciar os Containers
```bash
docker compose up -d --build
sleep 30
```

### 3️⃣ Acessar no Navegador
```
http://localhost:8000
```

✅ **Pronto!** Sua aplicação está rodando.

---

## 🤖 Alternativa: Setup Automático

Se preferir uma instalação completamente automatizada:

```bash
./setup.sh
```

Este script valida dependências, inicia containers, e verifica se tudo está funcionando.

---

## ⚙️ Configuração Manual Detalhada

Para um guia passo-a-passo completo com explicações detalhadas, consulte [SETUP_GUIDE.md](./SETUP_GUIDE.md).

### Pré-requisitos
- Git
- Docker
- Docker Compose

> ⚠️ Não é necessário instalar PHP, MySQL, Node ou NPM em sua máquina.
> Tudo rodará dentro do Docker.

### Instalação

```bash
git clone https://github.com/niltonrvazdev/gerenciador-produto.git
cd gerenciador-produto
docker compose up -d --build
```

---

## � Documentação

| Arquivo | Descrição |
|---------|-----------|
| [SETUP_GUIDE.md](./SETUP_GUIDE.md) | Guia completo de setup com todos os detalhes |
| [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) | Análise técnica do erro 502 e resolução |
| [DEBUG_CHECKLIST.md](./DEBUG_CHECKLIST.md) | Checklist rápido para diagnóstico de problemas |
| [CHANGELOG.md](./CHANGELOG.md) | Histórico de alterações e hotfixes |
| [RESUMO_EXECUTIVO.md](./RESUMO_EXECUTIVO.md) | Resumo técnico da solução implementada |

---

## 🔧 Comandos Úteis

```bash
# Ver status dos containers
docker compose ps

# Ver logs da aplicação
docker compose logs -f app

# Parar a aplicação
docker compose down

# Reiniciar
docker compose restart

# Acessar terminal do container
docker compose exec app bash

# Compilar assets (CSS/JavaScript)
docker compose exec app npm run build

# Rodar migrations
docker compose exec app php artisan migrate

# Criar usuário de teste
docker compose exec app php artisan tinker
# E dentro do Tinker:
# >>> User::factory()->create(['email' => 'test@example.com']);
```

---

## 🌐 URLs de Acesso

| Serviço | URL |
|---------|-----|
| Aplicação | http://localhost:8000 |
| MySQL | localhost:3306 |
| Nginx | http://localhost:8000 |

---

## 🐛 Encontrou um Erro?

1. **Execute o diagnóstico:**
   ```bash
   ./validate_502_fix.sh
   ```

2. **Consulte o checklist:**
   ```bash
   cat DEBUG_CHECKLIST.md
   ```

3. **Leia a análise técnica:**
   ```bash
   cat TROUBLESHOOTING.md
   ```

---

## �📌 Funcionalidades Implementadas

### 💻 Interface Web
- **Vitrine Pública:** Listagem de produtos em cards responsivos com imagem, nome, descrição e preço.
- **Painel de Gerenciamento:** Área restrita para usuários autenticados com CRUD completo e interface em tabela.
- **Upload de Fotos:** Processamento e armazenamento de imagens físicas no servidor local.
- **Filtros de Busca:** Pesquisa por nome (pública) e filtro de estoque mínimo (exclusivo para admin).
- **Feedback Visual:** Mensagens de sucesso padronizadas com fechamento automático.

### 🌐 API RESTful Protegida
- **Autenticação:** Endpoints protegidos por Bearer Token.
- **Resposta Padronizada:** Segue o formato: `{ data, message, errors }`.
- **Endpoints:** Listagem, Cadastro, Atualização e Exclusão.

---

## 🏛️ Arquitetura e SOLID

- **S (Single Responsibility):** Toda a lógica de negócio e manipulação de arquivos isolada na classe `ProductService`.
- **D (Dependency Inversion):** Controllers dependem da camada de serviço injetada via construtor.
- **Clean Code:** Uso de `FormRequests` para validação e `JsonResources` para padronização da API.

---

## 📸 Demonstração Visual

### 🎨 Interface do Usuário (Web)

| Animação GIF Demonstrando o sistema.
![GerenciadorProdutos](https://github.com/user-attachments/assets/e6fe8a8a-7a59-432b-92f0-dc8c914119ce)

| Vitrine de Produtos (Público) | Painel Administrativo (Logado) |
|---|---|
| ![vitrine](https://github.com/user-attachments/assets/a918c39f-b5fb-45a0-abc5-dae89a553c6f) | ![admin](https://github.com/user-attachments/assets/ea93e988-ca08-45aa-816b-1f6cdefcae2a) |

#### Fluxos de Gestão
- **Autenticação (Login e Registro):**
![login](https://github.com/user-attachments/assets/91e50f8a-35e9-4343-a746-5ff26f82a2f9)
![register](https://github.com/user-attachments/assets/acad0822-c499-44f1-805c-4162103f3272)

- **Cadastro e Edição:**
![create](https://github.com/user-attachments/assets/3f12d7c6-6389-447d-92c2-f7881c81f743)
![edit](https://github.com/user-attachments/assets/136e00c0-5609-4943-b7f9-75c1899da47d)

- **Busca e Perfil:**
![search](https://github.com/user-attachments/assets/8d1f8d28-90be-4b84-af1f-4ba627823708)
![profile](https://github.com/user-attachments/assets/c459edf2-5670-45d6-a356-a6a3440affc1)

---

### 🛠️ API RESTful (Postman)

**Listagem:**
![listar](https://github.com/user-attachments/assets/7cb6f9fb-40ee-422f-9b1c-a5eaaddca3c1)

**Cadastro:**
![cadastrar](https://github.com/user-attachments/assets/8fc8e489-7470-4760-ad06-577021adb022)
**Exemplo**
{
    "name": "Teclado Mecânico RGB2",
    "description": "Switch Brown, ABNT2",
    "price": 350.90,
    "stock": 15,
    "image_url": ""
}
**Atualização:**
![atualizar](https://github.com/user-attachments/assets/6d08308f-1ccc-4e6a-8e25-eef73e6f9eda)
**Exemplo**
{
    "name": "Relogio",
    "description": "Verde",
    "price": 54.90,
    "stock": 15,
    "image_url": ""
}

**Exclusão:**
![excluir](https://github.com/user-attachments/assets/ae6bbb40-a845-498e-b78b-c32b80558d1e)
**Exemplo**
http://localhost:8000/api/products/valor_do_gregistro_a_ser_excluido

---

## 🛠️ Stack Tecnológico

| Componente | Tecnologia | Versão |
|-----------|-----------|--------|
| Framework Web | Laravel | 12.x |
| Linguagem | PHP | 8.3 |
| Banco de Dados | MySQL | 8.0 |
| Web Server | Nginx | Alpine |
| Node Runtime | Node.js | v22 |
| Build Tool | Vite | 7.0.7 |
| CSS Framework | Tailwind CSS | 3.1.0 |
| JavaScript | Alpine.js | 3.x |
| Containerização | Docker | Latest |
| Orquestração | Docker Compose | Latest |

---

## 📈 Arquitetura

```
┌─────────────────────────────────────────────┐
│  Navegador (http://localhost:8000)          │
└────────────────────┬────────────────────────┘
                     │
    ┌────────────────┴──────────────────┐
    │    Docker Compose Network        │
    │                                   │
    ├──────────────────────────────────┤
    │  nginx:alpine (Port 8000)        │
    │  ↓                               │
    │  app (PHP 8.3 + Laravel 12)      │
    │  ↓                               │
    │  mysql:8.0                       │
    │                                   │
    │  Volume mounts for dev:          │
    │  - /app → projeto local          │
    │  - /storage → storage/           │
    └──────────────────────────────────┘
```

---

**Desenvolvido por Nilton Rodrigues Vaz** 🚀
```
