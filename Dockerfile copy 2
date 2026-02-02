FROM ubuntu:22.04

# Instala o necessário para rodar sua aplicação (exemplo)
RUN apt-get update && apt-get install -y ca-certificates

WORKDIR /app

# Remova o COPY . . se não houver arquivos no Git
# Defina as variáveis que o Coolify vai preencher
ENV KLANGO_PAYLOAD=""
ENV KLANGO_STATION_ID=""
ENV USER_ID=""
ENV PLAN=""

# Em vez de ./start.sh, coloque o comando real que inicia seu worker
# Exemplo se for um binário ou script inline:
CMD ["sh", "-c", "echo 'Iniciando Station $KLANGO_STATION_ID...' && seu-comando-aqui"]