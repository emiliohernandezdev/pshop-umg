#!/bin/bash
set -e

PORT="${PORT:-10000}"

# 1. Ajustar el puerto de Apache para Render
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/g" /etc/apache2/sites-available/000-default.conf

# 2. SOLUCIÓN RÁPIDA: Parchar SOLO el instalador (evita congelar el contenedor)
if [ -d /var/www/html/install ]; then
    echo "Parchando el instalador para omitir MyISAM..."
    find /var/www/html/install -type f \( -name "*.php" -o -name "*.sql" \) -exec sed -i 's/MyISAM/InnoDB/g' {} +
fi

# 3. Arrancar el contenedor de forma inmediata
if [ -f /usr/local/bin/docker-entrypoint.sh ]; then
    exec /usr/local/bin/docker-entrypoint.sh apache2-foreground
else
    exec apache2-foreground
fi
