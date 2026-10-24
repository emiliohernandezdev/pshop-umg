FROM prestashop/prestashop:latest

# Forzar a Apache a escuchar en todas las interfaces (0.0.0.0:80) para que Fly.io pueda conectarse
RUN sed -i "s/Listen 80/Listen 0.0.0.0:80/g" /etc/apache2/ports.conf || true
RUN sed -i "s/\*:80/0.0.0.0:80/g" /etc/apache2/sites-available/000-default.conf || true
