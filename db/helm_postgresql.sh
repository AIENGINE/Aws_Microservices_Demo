#!/bin/sh
helm repo add demo-postgres https://charts.bitnami.com/bitnami;
helm repo update;

helm_output=$(helm install --set primary.persistence.existingClaim=postgresql-pvc --set volumePermissions.enabled=true --set global.storageClass=gp2 --set global.postgresql.auth.username=postgresuser --set global.postgresql.auth.password="postgrespass" --set global.postgresql.auth.database=postgres demo-postgres demo-postgres/postgresql);
echo $helm_output > helm_instruction_output.txt