FROM prestashop/prestashop:latest

# Copiar el script de entrada personalizado
COPY entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

# Definir el entrypoint
ENTRYPOINT ["/tmp/entrypoint.sh"]
