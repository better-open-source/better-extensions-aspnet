ARG DotnetVersion=3.1
FROM mcr.microsoft.com/dotnet/core/sdk:$DotnetVersion-alpine AS build
WORKDIR /app

COPY ./BetterExtensions.AspNet.sln ./
COPY ./src/BetterExtensions.AspNet/BetterExtensions.AspNet.csproj ./src/BetterExtensions.AspNet/
COPY ./tests/BetterExtensions.AspNet.Tests/BetterExtensions.AspNet.Tests.csproj ./tests/BetterExtensions.AspNet.Tests/

RUN dotnet restore ./src/BetterExtensions.AspNet/BetterExtensions.AspNet.csproj
RUN dotnet restore ./tests/BetterExtensions.AspNet.Tests/BetterExtensions.AspNet.Tests.csproj

COPY . ./

ARG CI_BUILDID
ARG CI_PRERELEASE

ENV CI_BUILDID ${CI_BUILDID}
ENV CI_PRERELEASE ${CI_PRERELEASE}

RUN dotnet build ./src/BetterExtensions.AspNet/BetterExtensions.AspNet.csproj -c Release --no-restore
RUN dotnet build ./tests/BetterExtensions.AspNet.Tests/BetterExtensions.AspNet.Tests.csproj -c Release --no-restore

RUN dotnet test ./tests/BetterExtensions.AspNet.Tests/BetterExtensions.AspNet.Tests.csproj -c Release --no-build --no-restore

RUN dotnet pack ./src/BetterExtensions.AspNet/BetterExtensions.AspNet.csproj -c Release --no-restore --no-build -o /app/out