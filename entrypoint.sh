#!/bin/bash
set -e

PORT="${PORT:-10000}"

# 1. Ajustar el puerto de Apache para Render
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/g" /etc/apache2/sites-available/000-default.conf

# 2. ELIMINAR MYISAM GLOBALMENTE: Reemplazar MyISAM por InnoDB en TODO el proyecto PrestaShop
# Esto evita que el instalador CLI falle silenciosamente en los archivos .sql internos
echo "Limpiando referencias a MyISAM en el código fuente para Aiven..."
find /var/www/html -type f \( -name "*.php" -o -name "*.sql" -o -name "*.txt" \) -exec sed -i 's/MyISAM/InnoDB/g' {} + || true
find /var/www/html -type f \( -name "*.php" -o -name "*.sql" -o -name "*.txt" \) -exec sed -i 's/myisam/innodb/g' {} + || true

# 3. Forzar variables para la instalación automática desatendida
export PS_INSTALL_AUTO=1
export PS_ENGINE="InnoDB"

# 4. Ejecutar el entrypoint original de PrestaShop
if [ -f /usr/local/bin/docker-entrypoint.sh ]; then
    exec /usr/local/bin/docker-entrypoint.sh apache2-foreground
else
    exec apache2-foreground
fi
