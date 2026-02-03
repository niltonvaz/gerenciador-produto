#!/bin/sh
set -e

cd /var/www/html

echo "🚀 Inicializando aplicação Laravel..."

# Instala dependências PHP
if [ ! -d "vendor" ]; then
  echo "📦 Instalando dependências PHP (composer)..."
  composer install --no-interaction --prefer-dist
fi

# Instala dependências JS
if [ ! -d "node_modules" ]; then
  echo "📦 Instalando dependências JS (npm)..."
  npm install
fi

# Build frontend
echo "⚡ Buildando assets (Vite)..."
npm run build

# Gera APP_KEY se não existir
if ! grep -q "APP_KEY=base64" .env; then
  echo "🔑 Gerando APP_KEY..."
  php artisan key:generate
fi

# Diretórios e permissões
echo "🔐 Ajustando permissões..."
mkdir -p storage/framework/{cache,sessions,views}
mkdir -p storage/app/public

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstr
