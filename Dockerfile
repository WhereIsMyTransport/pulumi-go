FROM mcr.microsoft.com/dotnet/sdk:5.0 AS builder
WORKDIR /app

#6 Install latest Azure CLI.
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash 
RUN az -v

# Install version-specific Pulumi and update PATH.
RUN curl -fsSL https://get.pulumi.com | sh -s -- --version "3.12.0"
ENV PATH "$PATH:/root/.pulumi/bin"
RUN pulumi version

ADD ./src/pulumi-go.sh ./pulumi-go.sh

# Make script executable.
RUN chmod +x pulumi-go.sh

WORKDIR /

# Using the exec form of ENTRYPOINT to allow passing in of Pulumi arguments via docker run.
ENTRYPOINT ["./app/pulumi-go.sh"]
