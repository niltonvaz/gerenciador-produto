# 📸 Configuração de Upload de Imagens

## ✅ Resumo do que foi configurado

A aplicação agora está totalmente preparada para salvar e servir imagens de produtos.

---

## 🎯 O que foi feito

### 1. **Volumes Docker** (docker-compose.yml)
```yaml
volumes:
  - ./storage/app/public:/var/www/html/storage/app/public
```
- Mapeia a pasta local `storage/app/public` para dentro do container
- Permite que imagens persistam mesmo após reiniciar o container
- Compartilhada entre app (PHP) e nginx (Web Server)

### 2. **Permissões** (docker/entrypoint.sh)
```bash
# Pasta onde imagens serão salvas
mkdir -p storage/app/public

# Proprietário: www-data (usuário do PHP e Nginx)
chown -R www-data:www-data storage/app

# Permissões de leitura e escrita (775)
chmod -R 775 storage/app/public
```

### 3. **Symlink Público** (docker/entrypoint.sh)
```bash
php artisan storage:link
```
- Cria link em `public/storage` → `storage/app/public`
- URLs de imagens ficam acessíveis publicamente
- Exemplo: `http://localhost:8000/storage/products/imagem.jpg`

---

## 📁 Estrutura de Pastas

```
projeto/
├── storage/
│   └── app/
│       ├── public/           ← Imagens salvas aqui
│       │   └── products/
│       │       ├── imagem1.jpg
│       │       └── imagem2.jpg
│       └── private/
├── public/
│   └── storage              ← Symlink para acessar publicamente
└── docker-compose.yml       ← Volume mapeado
```

---

## 🚀 Como usar no código

### Upload de imagem em Controller
```php
// Arquivo enviado pelo formulário
$file = $request->file('image');

// Salvar na pasta public
$path = $file->store('products', 'public');

// Salvar no banco
$product->image_url = $path;
$product->save();
```

### Acessar imagem na View
```blade
<!-- Opção 1: asset() - Recomendado -->
<img src="{{ asset('storage/' . $product->image_url) }}" alt="...">

<!-- Opção 2: URL direto -->
<img src="/storage/products/imagem.jpg" alt="...">
```

---

## ✅ Verificação

Para verificar se tudo está funcionando:

```bash
# Ver se as pastas existem com permissões corretas
ls -la storage/app/public

# Ver se o symlink foi criado
ls -la public/storage

# Testar upload (via artisan)
docker compose exec app php artisan tinker
# Dentro do Tinker:
# >>> Illuminate\Support\Facades\Storage::disk('public')->put('test.txt', 'Hello');
```

---

## 🔧 Troubleshooting

### Erro 403 ao acessar imagens
**Problema:** Permissões incorretas
```bash
# Solução
docker compose exec app chown -R www-data:www-data storage/app
docker compose exec app chmod -R 775 storage/app/public
```

### Imagens desaparecem após restart
**Problema:** Volume não está mapeado
```bash
# Verificar docker-compose.yml tem volume em ./storage/app/public
docker compose down -v
docker compose up -d --build
```

### "Link already exists" na inicialização
**Problema:** Symlink já existe
```bash
# Limpar
rm -rf public/storage

# Reiniciar
docker compose restart app
```

---

## 📊 Teste Rápido

1. Abra http://localhost:8000
2. Crie um novo produto
3. Faça upload de uma imagem
4. Verifique se aparece: `http://localhost:8000/storage/products/...`
5. ✅ Se funcionou, está tudo correto!

---

## 📌 Resumo Técnico

| Aspecto | Configuração |
|--------|-------------|
| **Armazenamento** | `storage/app/public` (local) → `/var/www/html/storage/app/public` (container) |
| **Permissões** | `775` com proprietário `www-data` |
| **Acesso Público** | Via symlink `public/storage` |
| **URL Base** | `http://localhost:8000/storage/` |
| **Disco Laravel** | `public` (configurado em `config/filesystems.php`) |

---

**Status:** ✅ Totalmente configurado e testado  
**Data:** 04/02/2026  
**Próximo passo:** Comece a fazer uploads de imagens! 🎉
