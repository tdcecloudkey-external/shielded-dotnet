FROM mcr.microsoft.com/dotnet/samples:dotnetapp-chiseled-8.0 AS chiseled

# final stage/image
FROM mcr.microsoft.com/dotnet/runtime:8.0.12-jammy
ENV APP_UID=1654 ASPNETCORE_HTTP_PORTS=8080 DOTNET_RUNNING_IN_CONTAINER=true DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

USER 1654
ENV DOTNET_VERSION=8.0.12

WORKDIR /app
COPY --chown=1654 --from=chiseled /app .

ENTRYPOINT ["./dotnetapp"]

LABEL org.opencontainers.image.source=https://github.com/tdcecloudkey-external/shielded-dotnet
