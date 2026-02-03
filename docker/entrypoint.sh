#!/bin/sh
set -e

if [ ! -d "vendor" ]; then
  composer install --no-interaction --prefer-dist
fi

if [ ! -d "node_modules" ]; then
  npm install
fi

npm run build

if ! grep -q "APP_KEY=base64" .env; then
  php artisan key:generate
fi

mkdir -p storage/framework/{cache,sessions,views}
mkdir -p storage/app/public

chmod -R 775 storage bootstrap/cache

if [ ! -L "public/storage" ]; then
  php artisan storage:link
fi

php artisan migrate --force
php artisan db:seed --force

exec php-fpm
