#!/bin/sh
set -e

cd /var/www/html

echo "🚀 Inicializando aplicação Laravel..."

# ===============================
# Aguarda o banco ficar pronto
# ===============================
echo "⏳ Aguardando MySQL..."
until php -r "
try {
    new PDO(
        'mysql:host=' . getenv('DB_HOST') . ';port=' . getenv('DB_PORT'),
        getenv('DB_USERNAME'),
        getenv('DB_PASSWORD')
    );
    echo 'MySQL pronto!';
} catch (Exception \$e) {
    exit(1);
}
"; do
  sleep 2
done

# ===============================
# Dependências PHP
# ===============================
if [ ! -d "vendor" ]; then
  echo "📦 Instalando dependências PHP (composer)..."
  composer install --no-interaction --prefer-dist
fi

# ===============================
# Dependências JS
# ===============================
if [ ! -d "node_modules" ]; then
  echo "📦 Instalando dependências JS (npm)..."
  npm install
fi

# ===============================
# Build frontend
# ===============================
echo "⚡ Buildando assets (Vite)..."
npm run build

# ===============================
# APP_KEY
# ===============================
if ! grep -q "APP_KEY=base64" .env; then
  echo "🔑 Gerando APP_KEY..."
  php artisan key:generate --force
fi

# ===============================
# Storage e permissões
# ===============================
echo "🔐 Ajustando permissões..."
mkdir -p storage/framework/{cache,sessions,views}
mkdir -p storage/app/public

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# ===============================
# MIGRATIONS (AQUI 👇)
# ===============================
if [ -f "artisan" ]; then
  echo "🗄️ Rodando migrations..."
  php artisan migrate --force
fi


echo "✅ Aplicação pronta!"

# ===============================
# Inicia o PHP-FPM
# ===============================
exec php-fpm
