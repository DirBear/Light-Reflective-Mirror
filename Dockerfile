# Building the project with temporary container
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /lrm
COPY ./ServerProject-DONT-IMPORT-INTO-UNITY ./
RUN dotnet publish LRM.sln -c Release -o /out/

# Creating the server container
FROM mcr.microsoft.com/dotnet/runtime:6.0-alpine 	

# Copying builded files
COPY --from=build /out/ /var/server

WORKDIR /var/server
# Copying config file
ENV NO_CONFIG="true"
ENV TRANSPORT_CLASS="kcp2k.KcpTransport"
ENV AUTH_KEY="Secret Auth Key"
ENV TRANSPORT_PORT="45555"
ENV UPDATE_LOOP_TIME="10"
ENV UPDATE_HEARTBEAT_INTERVAL="100"
ENV RANDOMLY_GENERATED_ID_LENGTH="5"
ENV USE_ENDPOINT="true"
ENV ENDPOINT_PORT="8080"
ENV ENDPOINT_SERVERLIST="true"
ENV ENABLE_NATPUNCH_SERVER="true"
ENV NAT_PUNCH_PORT="7776"
ENV USE_LOAD_BALANCER="false"
ENV LOAD_BALANCER_AUTH_KEY="AuthKey"
ENV LOAD_BALANCER_ADDRESS="127.0.0.1"
ENV LOAD_BALANCER_PORT="7070"
ENV LOAD_BALANCER_REGION="1"
ENV KCP_NODELAY="true"
ENV KCP_INTERVAL="10"
ENV KCP_FAST_RESEND="2"
ENV KCP_CONGESTION_WINDOW="false"
ENV KCP_SEND_WINDOW_SIZE="4096"
ENV KCP_RECEIVE_WINDOW_SIZE="4096"
ENV KCP_CONNECTION_TIMEOUT="100000"

# Exposing port (Need to match those from config file)
EXPOSE ${TRANSPORT_PORT}/udp
EXPOSE ${NAT_PUNCH_PORT}/udp
EXPOSE ${ENDPOINT_PORT}

# Launch
ENTRYPOINT ["./LRM"]
