FROM node:20-slim

# 1. Instala dependências do sistema
# Adicionei o comando 'clean' e forcei o update para evitar o erro de saída 1
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl unzip libicu-dev libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. Configuração do Node
COPY package*.json ./
RUN npm install
COPY . .

# 3. Download e Extração do Worker
# Certifique-se de que a URL está acessível pelo servidor do Coolify
RUN curl -L -o worker.zip "https://klangorpa.com/workerdownload/klangoRpa-Worker.zip" && \
    mkdir -p ./dotnet_worker && \
    unzip worker.zip -d ./dotnet_worker && \
    chmod +x ./dotnet_worker/KlangoRPAConsole && \
    rm worker.zip

# 4. Configurações de ambiente
ENV KLANGO_PAYLOAD=""
ENV KLANGO_STATION_ID=""
ENV USER_ID=""
ENV PLAN=""

EXPOSE 3000

# 5. Execução (Roda o .NET em background e o Node em foreground)
CMD ./dotnet_worker/KlangoRPAConsole & npm start
