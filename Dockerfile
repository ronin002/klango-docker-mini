# Usamos o SDK para poder criar e compilar o projeto
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Limpeza e atualização do sistema
RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1. Cria um novo projeto console C#
# 2. Publica o projeto para a pasta 'out'
RUN dotnet new console -n TesteBuild && \
    dotnet publish -c Release -o out TesteBuild/TesteBuild.csproj

# Estágio Final: Usa a imagem leve (runtime) para rodar
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Copia apenas o resultado da compilação do estágio anterior
COPY --from=build /app/out .

# Como o nome do projeto no 'dotnet new' foi TesteBuild, a DLL será TesteBuild.dll
ENTRYPOINT ["dotnet", "TesteBuild.dll"]