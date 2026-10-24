#!/bin/bash
set -x
set -e

# Render asigna el puerto en la variable PORT (por defecto 10000)
PORT="${PORT:-10000}"

# Reemplazar el puerto 80 por el puerto de Render en la configuración de Apache
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/g" /etc/apache2/sites-available/000-default.conf

# ==========================================
# PARCHE PARA AIVEN: Forzar InnoDB en el instalador
# ==========================================
if [ -d /var/www/html/install ]; then
    echo "Aplicando parche para reemplazar MyISAM por InnoDB en el instalador..."
    find /var/www/html/install -type f -exec sed -i 's/MyISAM/InnoDB/g' {} +
fi

# Ejecutar el entrypoint original de PrestaShop
if [ -f /usr/local/bin/docker-entrypoint.sh ]; then
    exec /usr/local/bin/docker-entrypoint.sh apache2-foreground
else
    exec apache2-foreground
fi
