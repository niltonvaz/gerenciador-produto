#!/bin/sh

echo "🚀 Iniciando Laravel no Docker..."

# Aguarda o banco
echo "⏳ Aguardando MySQL..."
until php artisan migrate:status > /dev/null 2>&1
do
  sleep 2
done

# Instala dependências
if [ ! -d "vendor" ]; then
  echo "📦 Rodando composer install..."
  composer install --no-interaction --prefer-dist
fi

if [ ! -d "node_modules" ]; then
  echo "📦 Rodando npm install..."
  npm install
fi

# Build Vite
echo "⚡ Rodando build do Vite..."
npm run build

# Key do Laravel
if ! grep -q "APP_KEY=base64" .env; then
  echo "🔑 Gerando APP_KEY..."
  php artisan key:generate
fi

# Migrations e seed
echo "🗄️ Rodando migrations..."
php artisan migrate --force

echo "🌱 Rodando seed..."
php artisan db:seed --force

# Permissões
chown -R www-data:www-data storage bootstrap/cache

echo "✅ Laravel pronto!"

exec "$@"
