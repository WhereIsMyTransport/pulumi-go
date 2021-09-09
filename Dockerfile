FROM mcr.microsoft.com/dotnet/sdk:5.0 AS builder
WORKDIR /app

#6 Install latest Azure CLI.
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash 
RUN az -v

# Install version-specific Pulumi and update PATH.
RUN curl -fsSL https://get.pulumi.com | sh -s -- --version "3.12.0"
ENV PATH "$PATH:/root/.pulumi/bin"
RUN pulumi version

# Copy contents into image.
# This should be mountable which would make this image reusable across projects.
#COPY ./DataTools.Aks ./

# Make script executable.
RUN chmod +x src/pulumi-go.sh

# Using the exec form of ENTRYPOINT to allow passing in of Pulumi arguments via docker run.
ENTRYPOINT ["./src/pulumi-go.sh"]