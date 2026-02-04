#!/bin/sh
set -e

cd /var/www/html

echo "🚀 Inicializando aplicação Laravel..."

# ===============================
# Aguarda MySQL
# ===============================
echo "⏳ Aguardando MySQL..."
COUNTER=0
MAX_RETRIES=30
until nc -z db 3306 2>/dev/null; do
  COUNTER=$((COUNTER + 1))
  if [ $COUNTER -ge $MAX_RETRIES ]; then
    echo "❌ MySQL não respondeu após $MAX_RETRIES tentativas"
    exit 1
  fi
  echo "Aguardando MySQL... (tentativa $COUNTER/$MAX_RETRIES)"
  sleep 2
done
echo "✅ MySQL está acessível"

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
npm run build || npm run dev || true

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
