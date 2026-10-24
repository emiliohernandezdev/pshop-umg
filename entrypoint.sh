#!/bin/bash
set -e

PORT="${PORT:-10000}"

# 1. Ajustar el puerto de Apache para Render
sed -i "s/Listen 80/Listen ${PORT}/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/g" /etc/apache2/sites-available/000-default.conf

# 2. Si el archivo de parámetros de PrestaShop no existe, lo creamos con tus datos de Aiven
PARAM_FILE="/var/www/html/app/config/parameters.php"

if [ ! -f "$PARAM_FILE" ]; then
    echo "Generando archivo de configuración para Aiven (InnoDB)..."
    
    # Asegurar que la carpeta existe
    mkdir -p /var/www/html/app/config

    cat <<EOF > "$PARAM_FILE"
<?php
return [
    'parameters' => [
        'database_host' => '${DB_SERVER}',
        'database_port' => '3306',
        'database_name' => '${DB_NAME}',
        'database_user' => '${DB_USER}',
        'database_password' => '${DB_PASSWD}',
        'database_prefix' => 'PSUMG_',
        'database_engine' => 'InnoDB',
        'mailer_transport' => 'smtp',
        'mailer_host' => '127.0.0.1',
        'mailer_user' => null,
        'mailer_password' => null,
        'secret' => '$(openssl rand -hex 16)',
        'ps_caching' => 'CacheMemcached',
        'ps_cache_enable' => false,
        'uuid' => '$(cat /proc/sys/kernel/random/uuid)'
    ]
];
EOF
    chown -R www-data:www-data /var/www/html/app/config
fi

# 3. Arrancar Apache
exec apache2-foreground
