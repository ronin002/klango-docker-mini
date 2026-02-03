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
    unzip /tmp/worker.zip -d /app/worker && \
    rm /tmp/worker.zip

# Tornar o worker executável (se necessário)
RUN chmod +x /app/worker/* || true

EXPOSE 3000

# Script de inicialização para rodar ambos os processos
CMD ["/bin/bash", "-c", "npm start & /app/worker/klangoRpa-Worker"]