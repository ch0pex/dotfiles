#!/bin/bash

helm repo add jfrog https://charts.jfrog.io
helm repo update

helm upgrade --install artifactory-cpp-ce --set artifactory.postgresql.auth.password=$1 jfrog/artifactory-cpp-ce --namespace artifactory-cpp-ce --create-namespace
