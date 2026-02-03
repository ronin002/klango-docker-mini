FROM node:20-slim

# Força o modo não interativo e tenta rodar o update com mirrors resilientes
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    libicu-dev \
    libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Configuração do Node
COPY package*.json ./
RUN npm install
COPY . .

# Download e Extração (substitua pela sua URL real)
# Adicionei a flag -k no curl caso seu servidor de download tenha SSL autoassinado
RUN curl -Lk -o worker.zip "https://klangorpa.com/workerdownload/klangoRpa-Worker.zip" && \
    mkdir -p ./dotnet_worker && \
    unzip worker.zip -d ./dotnet_worker && \
    chmod +x ./dotnet_worker/KlangoRPAConsole && \
    rm worker.zip

EXPOSE 3000

# Executa ambos os processos
CMD ./dotnet_worker/KlangoRPAConsole & npm start

