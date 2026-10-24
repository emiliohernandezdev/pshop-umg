FROM prestashop/prestashop:latest

# Respaldar los archivos originales antes de montar el volumen persistente
RUN mkdir -p /usr/src/prestashop && cp -RT /var/www/html /usr/src/prestashop

# Copiar el script de entrada
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    sed -i 's/\r$//' /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
