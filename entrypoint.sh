#!/bin/bash
set -e

PORT="${PORT:-10000}"

# 1. Ajustar el puerto de Apache para Render
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/g" /etc/apache2/sites-available/000-default.conf

# 2. PARCHE CRÍTICO: Reemplazar MyISAM por InnoDB en los archivos de instalación
# Esto evita que Aiven rechace la creación de tablas temporales/fijas del core de PrestaShop
if [ -d /var/www/html/install ]; then
    echo "Aplicando parche: cambiando MyISAM por InnoDB en el instalador..."
    find /var/www/html/install -type f -exec sed -i 's/MyISAM/InnoDB/g' {} +
fi

if [ -d /var/www/html/classes ]; then
    find /var/www/html/classes -type f -exec sed -i 's/ENGINE=MyISAM/ENGINE=InnoDB/g' {} + || true
fi

# 3. Ejecutar el entrypoint original de PrestaShop (permitiendo que corra la instalación automática CLI)
if [ -f /usr/local/bin/docker-entrypoint.sh ]; then
    exec /usr/local/bin/docker-entrypoint.sh apache2-foreground
else
    exec apache2-foreground
fi
