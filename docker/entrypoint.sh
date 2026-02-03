#!/bin/sh
set -e

echo "Starting Laravel container..."

# -------------------------------------------------
# Install PHP dependencies
# -------------------------------------------------
if [ ! -d "vendor" ]; then
  composer install --no-interaction --prefer-dist
fi

# -------------------------------------------------
# Install Node dependencies and build assets
# -------------------------------------------------
if [ ! -d "node_modules" ]; then
  npm install
fi

npm run build

# -------------------------------------------------
# Ensure .env exists
# -------------------------------------------------
if [ ! -f ".env" ]; then
  echo ".env file not found. Container stopped."
  exit 1
fi

# -------------------------------------------------
# Generate APP_KEY if missing
# -------------------------------------------------
if ! grep -q "APP_KEY=base64" .env; then
  php artisan key:generate
fi

# -------------------------------------------------
# Prepare storage directories and permissions
# -------------------------------------------------
mkdir -p storage/framework/cache
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
mkdir -p storage/app/public

chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# -------------------------------------------------
# Create storage symlink (for uploads)
# -------------------------------------------------
if [ ! -L "public/storage" ]; then
  php artisan storage:link
fi

# -------------------------------------------------
# Run database migrations and seeders
# -------------------------------------------------
php artisan migrate --force
php artisan db:seed --force

echo "Laravel is ready."

exec "$@"
