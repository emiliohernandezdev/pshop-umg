FROM prestashop/prestashop:latest

# Copiar el entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Dar permisos y limpiar saltos de línea por si se editó en Windows
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    sed -i 's/\r$//' /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
