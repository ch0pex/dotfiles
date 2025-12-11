#!/bin/bash

helm upgrade --install artifactory-cpp-ce \
  --set artifactory.nginx.enabled=false \
  --set artifactory.ingress.enabled=true \
  --set artifactory.ingress.hosts[0]="artifactory.company.com" \
  --set artifactory.artifactory.service.type=NodePort \
  jfrog/artifactory-cpp-ce --namespace artifactory-cpp-ce --create-namespace
