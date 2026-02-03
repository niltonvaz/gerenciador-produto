#!/bin/sh
set -e

echo "🚀 Iniciando Laravel..."

cd /var/www/html

# Garantir .env
if [ ! -f ".env" ]; then
  cp .env.example .env
fi

# Dependências PHP
if [ ! -d "vendor" ]; then
  echo "📦 Instalando dependências PHP..."
  composer install --no-interaction --prefer-dist
fi

# Dependências JS
if [ ! -d "node_modules" ]; then
  echo "📦 Instalando dependências JS..."
  npm install
fi

echo "⚡ Build do frontend..."
npm run build || true

# APP KEY
if ! grep -q "^APP_KEY=base64" .env; then
  echo "🔑 Gerando APP_KEY..."
  php artisan key:generate --force
fi

# Pastas obrigatórias
mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views
mkdir -p storage/app/public

# Permissões corretas
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Storage link
if [ ! -L "public/storage" ]; then
  php artisan storage:link
fi

# Banco
php artisan migrate --force || true
php artisan db:seed --force || true

echo "✅ Laravel pronto. Iniciando PHP-FPM..."

exec php-fpm
