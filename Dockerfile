# docker build -t pulumi-go:latest .
# docker run --rm -it --mount type=bind,source="$(pwd)",target=/project -e PULUMI_BACKEND="azblob://pulumi" -e AZURE_STORAGE_ACCOUNT="datatoolsstates" -e AZURE_STORAGE_KEY="{secret}" -e PULUMI_CONFIG_PASSPHRASE="{secret}" -e ARM_CLIENT_ID="653ff6aa-6e8a-440f-9cba-5f3f173b6927" -e ARM_CLIENT_SECRET="{secret}" -e ARM_TENANT_ID="96c25cb6-0b7b-4ca9-885a-685f0168d0cb" -e ARM_SUBSCRIPTION_ID="bc11037b-06b4-4279-aab3-6ad4688a29f6" whereismytransport.azurecr.io/pulumi-go:latest preview -s preprod

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
