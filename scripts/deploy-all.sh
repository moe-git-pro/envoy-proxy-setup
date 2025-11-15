#!/bin/bash

echo "Starting Envoy Gateway deployment..."

echo "Applying internal-infra-ca-issuer..."
microk8s kubectl apply -f 05-internal-infra-ca-issuer.yaml

echo "Applying gatewayclass..."
microk8s kubectl apply -f 01-gatewayclass.yaml

echo "Applying gateway..."
microk8s kubectl apply -f 02-gateway.yaml

echo "Applying HTTP to HTTPS redirect..."
microk8s kubectl apply -f 03-http-to-https-redirect.yaml

echo "Applying routes..."
microk8s kubectl apply -f 04-routes.yaml

echo "Applying certificate..."
microk8s kubectl apply -f 06-certificate.yaml

echo "Applying loadbalancer service..."
microk8s kubectl apply -f 07-service.yaml

echo "Deployment completed successfully!"

echo "Waiting for all resources to be ready..."
microk8s kubectl wait --timeout=3m -n internal-infra certificate/testapi-cert --for=condition=Ready
microk8s kubectl wait --timeout=3m -n internal-infra gateway-gateway --for=condition=Programmed

echo "All resources are ready!"
