FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

ENV ASPNETCORE_URLS=http://0.0.0.0:5391
ENV DOTNET_EnableDiagnostics=0

COPY artifacts/Atlas.McpServer/ ./

EXPOSE 5391
ENTRYPOINT ["dotnet", "Atlas.McpServer.dll"]
