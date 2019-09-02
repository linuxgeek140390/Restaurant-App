#!/bin/sh

dotnet tool install --global dotnet-sonarscanner --version 4.6.2
PATH="${PATH}:/root/.dotnet/tools"

dotnet test Identity.API.UnitTests/Identity.API.UnitTests.csproj \
    /p:CollectCoverage=true \
    /p:CoverletOutputFormat=opencover

dotnet build-server shutdown

dotnet sonarscanner begin \
     /d:"sonar.host.url=https://sonarcloud.io" \
     /o:"restaurant-app" \
     /k:"restaurant-identity-api" \
     /d:"sonar.login=77a854f90e4e5cf4f26de587be88715750a2a9cc" \
     /d:sonar.cs.opencover.reportsPaths="Identity.API.UnitTests/coverage.opencover.xml" \
     /d:sonar.coverage.exclusions="**Tests*.cs"

dotnet build Identity.API.sln
dotnet sonarscanner end /d:sonar.login="77a854f90e4e5cf4f26de587be88715750a2a9cc"