# 📦 Gerenciador de Produtos - Laravel 12 & Docker

Este projeto é uma solução completa para gerenciamento de produtos, desenvolvida com **Laravel 12** e **PHP 8.2**. A aplicação segue as melhores práticas de desenvolvimento, utilizando princípios **SOLID**, **Clean Code** e **Arquitetura em Camadas (Service Layer)**.

## 🛠️ Tecnologias e Ferramentas

- **Framework:** Laravel 12
- **Linguagem:** PHP 8.2
- **Banco de Dados:** MySQL 8.0
- **Containerização:** Docker & Docker Compose
- **Autenticação Web:** Laravel Breeze (Blade + Tailwind)
- **Autenticação API:** Laravel Sanctum (Bearer Token)
- **Testes:** PHPUnit

---

## 🚀 Como Executar a Aplicação

Siga os passos abaixo para configurar o ambiente em sua máquina local:

### 1. Clonar o Repositório
```bash
git clone https://github.com/SEU_USUARIO/NOME_DO_REPO.git
cd gerenciador-produto
```

### 2. Configurar Variáveis de Ambiente
```bash
cp .env.example .env
```
*Nota: Verifique se os valores de banco no `.env` coincidem com o `docker-compose.yml`.*

### 3. Subir o Ambiente Docker
```bash
docker compose up -d
```

### 4. Instalar Dependências e Preparar o Banco
Execute os comandos abaixo para configurar o Laravel dentro do container:
```bash
# Instalar dependências
docker exec gerenciador_app composer install

# Gerar chave da aplicação
docker exec gerenciador_app php artisan key:generate

# Criar link simbólico para as imagens (Storage)
docker exec gerenciador_app php artisan storage:link

# Rodar Migrations e Seeders
docker exec gerenciador_app php artisan migrate --seed
```
**Acesso:** [http://localhost:8000](http://localhost:8000)

---

## 🧪 Como Executar os Testes

A aplicação conta com uma suíte de testes unitários e de integração que garantem a integridade das regras de negócio.
```bash
docker exec gerenciador_app php artisan test
```

---

## 📌 Funcionalidades Implementadas

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

**Atualização:**
![atualizar](https://github.com/user-attachments/assets/6d08308f-1ccc-4e6a-8e25-eef73e6f9eda)

**Exclusão:**
![excluir](https://github.com/user-attachments/assets/ae6bbb40-a845-498e-b78b-c32b80558d1e)

---

**Desenvolvido por Nilton Rodrigues Vaz** 🚀
```
