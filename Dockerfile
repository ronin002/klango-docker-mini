# Usar Ubuntu 24.04 que tem GLIBC 2.38 e GLIBCXX_3.4.32
FROM ubuntu:24.04

# Instalar .NET 8.0 SDK e dependências
RUN apt-get update && \
    apt-get install -y wget curl unzip && \
    wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-8.0

# Instalar Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Limpar cache do apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

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
ENV KLANGO_MID=""
ENV PLAN=""

# Baixar e extrair o worker klangorpa-worker-linux-container.zip
#RUN wget https://klangorpa.com/workerdownload/klangoRpa-Worker.zip -O /tmp/worker.zip && \
RUN wget https://klangorpa.com/workerdownload/klangorpa-worker-linux-container.zip -O /tmp/worker.zip && \
    unzip /tmp/worker.zip -d /app/worker && \
    rm /tmp/worker.zip && \
    chmod +x /app/worker/publish/KlangoRPAConsole

EXPOSE 3000

# Script de inicialização
CMD ["/bin/bash", "-c", "\
    echo '=== Iniciando servidor Node ===' && \
    npm start & \
    sleep 3 && \
    echo '=== Iniciando KlangoRPA Worker ===' && \
    cd /app/worker/publish && \
    ./KlangoRPAConsole \
"]