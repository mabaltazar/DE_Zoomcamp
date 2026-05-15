#!/bin/bash
set -e

echo "=== Installing Google Cloud CLI ==="
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl

# Add Google's package signing key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Add the gcloud apt repository
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
  https://packages.cloud.google.com/apt cloud-sdk main" | \
  sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

# Install
sudo apt-get update -y && sudo apt-get install -y google-cloud-cli

echo "=== Verifying installations ==="
terraform -version
gcloud --version
echo "=== Setup complete ==="