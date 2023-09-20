# Use the official .NET 7.0 SDK image as the build environment
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory in the container to the "API" directory
WORKDIR /app/API

# Copy the project file and restore any dependencies
COPY API/*.csproj ./
RUN dotnet restore

# Copy the remaining application code
COPY API/ ./

# Build the application with release configuration
RUN dotnet publish -c Release -o out

# Use the official .NET 7.0 runtime image for the final image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# Set the working directory in the container to the "API" directory
WORKDIR /app/API

# Copy the published application from the build environment
COPY --from=build /app/API/out ./

# Expose the port your application will listen on
EXPOSE 80

# Define the entry point for your application
ENTRYPOINT ["dotnet", "API.dll"]