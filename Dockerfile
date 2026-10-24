FROM prestashop/prestashop:latest

# Copiar el script de entrada
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Asegurar permisos de ejecución y limpiar saltos de línea de Windows (CRLF a LF)
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    sed -i 's/\r$//' /usr/local/bin/entrypoint.sh

# Definir el entrypoint actualizado
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
