#!/bin/bash

# Go to Pulumi project directory (mounted at runtime).
cd project

# Hello!
echo ╔════════════════════╗
echo ║ Running pulumi-go! ║
echo ╚════════════════════╝
echo Pulumi command: $@
echo Current path: $(pwd -P)
echo Dir contents: $(ls)

# Login to Pulumi backend. 
# Requires AZURE_STORAGE_ACCOUNT, AZURE_STORAGE_KEY and PULUMI_CONFIG_PASSPHRASE env variables for Azure storage.
pulumi login $PULUMI_BACKEND --non-interactive --color never --logtostderr

# Run Pulumi with the provided command (and arguments) provided at docker run.
# Requires ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID, ARM_SUBSCRIPTION_ID environment variables.
# These provide Azure privileges by service principal - https://www.pulumi.com/docs/intro/cloud-providers/azure/setup/#service-principal-authentication
pulumi $@ --non-interactive --color never --logtostderr

# Note: pulumi does not use standard exit codes so using stderr is necessary. 