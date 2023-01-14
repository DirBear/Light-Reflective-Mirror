# Building the project with temporary container
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /lrm
COPY . .
RUN dotnet publish LRM.sln -c Release -o /out/

# Creating the server container
FROM mcr.microsoft.com/dotnet/runtime:6.0-alpine

# Copying builded files
COPY --from=build /out/ /var/server

WORKDIR /var/server
# Copying config file
ENV NO_CONFIG="true"
ENV TRANSPORT_CLASS="kcp2k.KcpTransport"
ENV AUTH_KEY=""
ENV TRANSPORT_PORT="45555"
ENV UPDATE_LOOP_TIME="100"
ENV UPDATE_HEARTBEAT_INTERVAL="100"
ENV RANDOMLY_GENERATED_ID_LENGTH="5"
ENV USE_ENDPOINT="true"
ENV ENDPOINT_PORT="8080"
ENV ENDPOINT_SERVERLIST="true"
ENV ENABLE_NATPUNCH_SERVER="false"
ENV NAT_PUNCH_PORT="7776"
ENV USE_LOAD_BALANCER="true"
ENV LOAD_BALANCER_AUTH_KEY="${API_KEY}"
ENV LOAD_BALANCER_ADDRESS="${COMPOSE_PROJECT_NAME}_load_balancer"
ENV LOAD_BALANCER_PORT="8080"
ENV LOAD_BALANCER_REGION="1"
ENV KCP_NODELAY="true"
ENV KCP_INTERVAL="10"
ENV KCP_FAST_RESEND="2"
ENV KCP_CONGESTION_WINDOW="false"
ENV KCP_SEND_WINDOW_SIZE="8192"
ENV KCP_RECEIVE_WINDOW_SIZE="8192"
ENV KCP_CONNECTION_TIMEOUT="10000"

# Exposing port (Need to match those from config file)

EXPOSE ${TRANSPORT_PORT}/udp
#EXPOSE ${NAT_PUNCH_PORT}/udp
EXPOSE ${ENDPOINT_PORT}

# Launch
ENTRYPOINT ["/var/server/LRM"]