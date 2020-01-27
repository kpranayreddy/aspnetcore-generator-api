# Build Stage
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env

WORKDIR /generator
# restore
COPY api/api.csproj ./api/
RUN dotnet restore api/api.csproj
COPY tests/tests.csproj ./tests/
RUN dotnet restore tests/tests.csproj 


# copy src
COPY . .
# test
RUN dotnet test tests/tests.csproj
# publish
RUN dotnet publish api/api.csproj -o /publish
# runtime
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /publish
COPY --from=build-env /publish /publish