#!/bin/sh
set -e

cd /var/www/html

echo "🚀 Inicializando aplicação Laravel..."

# ===============================
# Aguarda MySQL
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
echo ""

# ===============================
# Composer
# ===============================
if [ ! -f "vendor/autoload.php" ]; then
  echo "📦 Instalando dependências PHP..."
  composer install --no-interaction --prefer-dist
fi

# ===============================
# Node
# ===============================
if [ ! -d "node_modules" ]; then
  echo "📦 Instalando dependências JS..."
  npm install
fi

echo "⚡ Buildando assets..."
npm run build

# ===============================
# APP_KEY
# ===============================
if ! grep -q "APP_KEY=base64" .env; then
  echo "🔑 Gerando APP_KEY..."
  php artisan key:generate --force
fi

# ===============================
# Permissões
# ===============================
mkdir -p storage/framework/{cache,sessions,views}
mkdir -p storage/app/public

chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# ===============================
# Tabelas internas Laravel
# ===============================
php artisan session:table || true
php artisan cache:table || true
php artisan queue:table || true

# ===============================
# Migrations
# ===============================
php artisan migrate --force

echo "✅ Laravel pronto!"
exec php-fpm -F
