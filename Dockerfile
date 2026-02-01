FROM ubuntu:22.04



# As variáveis estarão disponíveis em runtime
ENV KLANGO_PAYLOAD=""
ENV KLANGO_STATION_ID=""
ENV USER_ID=""
ENV PLAN=""

# Seu código que usa essas variáveis
COPY . /app
WORKDIR /app

CMD ["./start.sh"]