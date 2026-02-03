#!/bin/bash

set -e

# 1. Espera o PostgreSQL iniciar
echo "⏳ Aguardando PostgreSQL iniciar (espera fixa de 15s)..."
sleep 15
echo "✅ PostgreSQL pronto!"

# 3. Inicializa o Superset
echo "🚀 Inicializando Superset..."
superset db upgrade

superset fab create-admin \
    --username "$SUPERSET_USER" \
    --firstname "$SUPERSET_FIRSTNAME" \
    --lastname "$SUPERSET_LASTNAME" \
    --email "$SUPERSET_EMAIL" \
    --password "$SUPERSET_PASSWORD" || true

superset init

# 4. Finaliza setup

echo "✅ Superset rodando em http://localhost:8088"
exec superset run -p 8088 -h 0.0.0.0