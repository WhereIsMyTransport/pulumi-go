# pulumi-go

Run your Pulumi commands in Docker for .NET 5.0 projects that deploy to Azure Cloud.  This means there is no need to install any local dependencies (Pulumi, .NET Core SDKs and the Azure CLI) - useful for continuous integration.

## Instructions

Run the Docker container with the Pulumi project root directory (i.e. where the Pulumi.yaml is located) mounted using the `--mount` argument.  See example further below.  Otherwise you can run the container from the path of your project and provide `$(pwd)` as the source binding - this will mount the Pulumi project into the container.

Any Pulumi commands and arguments can be specified and executed, however it is limited to a single command.  This means that you cannot chain together consecutive Pulumi commands.  For example, running `pulumi stack select preprod` and then `pulumi up` will not work because the commands are run in two separate sessions.  However, using the example, the same outcome can be achieved using the single command `pulumi up -s preprod`.

The container requires the following environment variable settings:
 - The Pulumi backend credentials (PULUMI_BACKEND, AZURE_STORAGE_ACCOUNT, AZURE_STORAGE_KEY, PULUMI_CONFIG_PASSPHRASE).  See more [here](https://www.pulumi.com/docs/intro/concepts/state/#logging-into-the-azure-blob-storage-backend).
 - Azure service principal credentials (ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID, ARM_SUBSCRIPTION_ID) with the relevant access right to services in the subscription. See [here](https://www.pulumi.com/docs/intro/cloud-providers/azure/setup/#service-principal-authentication).

For example, running the equivalent of `pulumi preview -s preprod`:

```
docker run --rm -it `
--mount type=bind,source="$(pwd)",target=/project `
-e PULUMI_BACKEND="azblob://pulumi" `
-e AZURE_STORAGE_ACCOUNT="datatoolsstates" `
-e AZURE_STORAGE_KEY="{secret}" `
-e PULUMI_CONFIG_PASSPHRASE="{secret}" `
-e ARM_CLIENT_ID="653ff6aa-6e8a-440f-9cba-5f3f173b6927" `
-e ARM_CLIENT_SECRET="{secret}" `
-e ARM_TENANT_ID="96c25cb6-0b7b-4ca9-885a-685f0168d0cb" `
-e ARM_SUBSCRIPTION_ID="bc11037b-06b4-4279-aab3-6ad4688a29f6" `
pulumi-go preview -s preprod
```

## Future work

This is very alpha. Some future work to consider:

 - Reduce the size of the image.  It's currently sitting at 1.9GB.
 - Be explicit about the version of Azure CLI to install
 - Support for other backend types and cloud providers