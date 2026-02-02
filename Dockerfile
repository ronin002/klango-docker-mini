# Usamos a sua base Node 20
FROM node:20-slim

# 1. Instala dependências mínimas para rodar o .NET (mesmo Self-Contained) e o curl/unzip
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    libicu-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. Configuração do Node (seu código original)
COPY package*.json ./
RUN npm install
COPY . .

# 3. Download e Preparação do Worker .NET
# Substitua a URL pelo link real do seu .zip (ex: do GitHub Releases ou S3)
RUN curl -L -o worker.zip "https://klangorpa.com/workerdownload/klangoRpa-Worker.zip" && \
    mkdir -p ./dotnet_worker && \
    unzip worker.zip -d ./dotnet_worker && \
    chmod +x ./dotnet_worker/KlangoRPAConsole && \
    rm worker.zip

ENV KLANGO_PAYLOAD=""
ENV KLANGO_STATION_ID=""
ENV USER_ID=""
ENV PLAN=""

EXPOSE 3000

# 4. Comando para iniciar
# Se você precisa que AMBOS (Node e .NET) rodem ao mesmo tempo, 
# você pode usar um script bash ou o operador '&' (mas o bash é mais seguro para logs)
CMD ./dotnet_worker/KlangoRPAConsole & npm start