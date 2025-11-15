#!/bin/bash

# Create directory for certificates
mkdir -p certs
cd certs

echo "Generating CA private key..."
openssl genrsa -out ca.key 4096

echo "Generating CA certificate..."
openssl req -x509 -new -nodes -key ca.key \\
  -subj "/C=US/ST=State/L=City/O=internal-infra/CN=internal-infra.net" \\
  -days 3650 -out ca.crt


# Create TLS secret with CA
echo "Creating Kubernetes secret for CA..."
microk8s kubectl create secret tls internal-infra-ca \\
  --cert=ca.crt --key=ca.key \\
  --namespace=internal-infra-app \\
  --dry-run=client -o yaml | microk8s kubectl apply -f -

# Verify secret creation
microk8s kubectl get secret internal-infra-ca -n internal-infra-app

echo "CA generation completed successfully!"
