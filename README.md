# 📦 Gerenciador de Produtos - Laravel 12 & Docker (Automação Total)

Este projeto é uma solução de alta performance para gerenciamento de produtos, desenvolvida com **Laravel 12** e **PHP 8.3**. A arquitetura foi desenhada para ser **"Zero Config"**, onde todo o ambiente (Servidor Nginx, Banco MySQL, Node.js para Assets e Dependências PHP) é configurado automaticamente via Docker.

**Repositório Oficial:** [https://github.com/niltonvaz/gerenciador-produto.git](https://github.com/niltonvaz/gerenciador-produto.git)
---

## 🚀 Instalação "Um Clique" (Full Automation)

Não é necessário ter PHP, Node ou MySQL instalados em sua máquina física. O sistema cuida de tudo.

### 1. # 🚀 Como rodar o projeto (passo a passo para iniciantes)

## ✅ Pré-requisitos
Antes de começar, você precisa ter instalado no seu computador:

- Git
- Docker
- Docker Compose

> ⚠️ Não é necessário instalar PHP, MySQL, Node ou NPM.
> Tudo isso será executado automaticamente dentro do Docker.

---

## 1️⃣ Baixar o projeto

Abra o terminal e execute:

```bash
git clone https://github.com/niltonvaz/gerenciador-produto.git

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

**Desenvolvido por Nilton Rodrigues Vaz** 🚀
```
