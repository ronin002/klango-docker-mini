# Stage 1: Imagem base com Node.js e .NET
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS base

# Instalar Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs unzip wget

WORKDIR /app

# Copiar e instalar dependências do Node
COPY package*.json ./
RUN npm install

# Copiar código da aplicação Node
COPY . .

# Variáveis de ambiente
ENV KLANGO_PAYLOAD=""
ENV KLANGO_STATION_ID=""
ENV USER_ID=""
ENV PLAN=""

# Baixar e extrair o worker
RUN wget https://klangorpa.com/workerdownload/klangoRpa-Worker.zip -O /tmp/worker.zip && \
    echo "=== Arquivo ZIP baixado ===" && \
    ls -lh /tmp/worker.zip && \
    unzip -l /tmp/worker.zip && \
    echo "=== Extraindo ZIP ===" && \
    unzip /tmp/worker.zip -d /app/worker && \
    echo "=== Conteúdo extraído ===" && \
    ls -laR /app/worker && \
    rm /tmp/worker.zip

# Tornar o worker executável (se necessário)
RUN find /app/worker -type f -name "*.exe" -o -name "*.dll" -o -name "*Worker*" | xargs chmod +x 2>/dev/null || true

EXPOSE 3000

# Script de inicialização com verificação
CMD ["/bin/bash", "-c", "\
    echo '=== Verificando estrutura do worker ===' && \
    ls -laR /app/worker && \
    echo '=== Iniciando servidor Node ===' && \
    npm start & \
    echo '=== Aguardando 3 segundos ===' && \
    sleep 3 && \
    echo '=== Procurando executável do worker ===' && \
    WORKER_EXEC=$(find /app/worker -type f -executable -o -name '*.exe' -o -name '*Worker*' | head -1) && \
    echo \"Worker encontrado em: $WORKER_EXEC\" && \
    if [ -f \"$WORKER_EXEC\" ]; then \
        cd $(dirname $WORKER_EXEC) && \
        if [[ \"$WORKER_EXEC\" == *.dll ]]; then \
            dotnet \"$WORKER_EXEC\"; \
        else \
            \"$WORKER_EXEC\"; \
        fi; \
    else \
        echo 'ERRO: Worker não encontrado!' && \
        echo 'Mantendo apenas o servidor Node rodando...' && \
        wait; \
    fi \
"]