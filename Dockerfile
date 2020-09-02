ARG DotnetVersion=3.1
FROM mcr.microsoft.com/dotnet/core/sdk:$DotnetVersion-alpine AS build
WORKDIR /app

COPY ./BetterExtensions.AspNet.sln ./
COPY ./src/BetterExtensions/BetterExtensions.csproj ./src/BetterExtensions/
COPY ./tests/BetterExtensions.Tests/BetterExtensions.Tests.csproj ./tests/BetterExtensions.Tests/

RUN dotnet restore ./src/BetterExtensions/BetterExtensions.csproj
RUN dotnet restore ./tests/BetterExtensions.Tests/BetterExtensions.Tests.csproj

COPY . ./

ARG CI_BUILDID
ARG CI_PRERELEASE

ENV CI_BUILDID ${CI_BUILDID}
ENV CI_PRERELEASE ${CI_PRERELEASE}

RUN dotnet build ./src/BetterExtensions/BetterExtensions.csproj -c Release --no-restore
RUN dotnet build ./tests/BetterExtensions.Tests/BetterExtensions.Tests.csproj -c Release --no-restore

RUN dotnet test ./tests/BetterExtensions.Tests/BetterExtensions.Tests.csproj -c Release --no-build --no-restore

RUN dotnet pack ./src/BetterExtensions/BetterExtensions.csproj -c Release --no-restore --no-build -o /app/out