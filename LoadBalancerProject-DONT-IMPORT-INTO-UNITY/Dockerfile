FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /lrm-lb
COPY . .
RUN dotnet publish LRM_LoadBalancer.sln -c Release -o /out

# Creating the server container
FROM mcr.microsoft.com/dotnet/runtime:6.0-alpine

# Copying builded files
COPY --from=build /out/ /var/load-balancer

WORKDIR /var/load-balancer

ENV NO_CONFIG="true"
ENV CONNECTED_SERVER_PING_RATE="10000"
ENV AUTH_KEY="${API_KEY}"
ENV ENDPOINT_PORT="8080"
ENV SHOW_DEBUG_LOGS="true"
ENV RANDOMLY_GENERATED_ID_LENGTH="5"
ENV IP_OVERRIDE="0.0.0.0"

EXPOSE ${ENDPOINT_PORT}


ENTRYPOINT ["/var/load-balancer/LRM_LoadBalancer"]