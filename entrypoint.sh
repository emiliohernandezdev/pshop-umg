#!/bin/bash
set -e

# Render asigna el puerto en la variable PORT (por defecto 10000)
PORT="${PORT:-10000}"

# 1. Ajustar el puerto de Apache para Render
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/g" /etc/apache2/sites-available/000-default.conf

# 2. PARCHE INSTANTÁNEO: Reemplazar MyISAM por InnoDB SOLO en el instalador
# Al limitar la búsqueda a /var/www/html/install, tarda 0.05 segundos y no congela nada.
if [ -d /var/www/html/install ]; then
    echo "Adaptando el instalador para Aiven (InnoDB)..."
    find /var/www/html/install -type f \( -name "*.sql" -o -name "*.php" \) -exec sed -i 's/MyISAM/InnoDB/g' {} +
fi

# 3. Forzar variables para que la instalación automática CLI corra sola
export PS_INSTALL_AUTO=1
export PS_ENGINE="InnoDB"

# 4. Arrancar el script oficial de PrestaShop (que creará las tablas en Aiven y levantará Apache)
if [ -f /usr/local/bin/docker-entrypoint.sh ]; then
    exec /usr/local/bin/docker-entrypoint.sh apache2-foreground
else
    exec apache2-foreground
fi
