#!/bin/bash

set -e

# 1. Aguarda PostgreSQL estar disponível
echo "⏳ Aguardando PostgreSQL..."
until pg_isready -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER; do
  sleep 2
done
echo "✅ PostgreSQL está pronto!"

# 2. Executa os scripts SQL (criação de schemas e views)
echo "⚙️ Executando run_all.sql..."
psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DB -f /sql/run_all.sql

# 3. Inicializa o Superset
echo "🚀 Inicializando Superset..."
superset db upgrade
superset fab create-admin \
    --username "$SUPERSET_USER" \
    --firstname "$SUPERSET_FIRSTNAME" \
    --lastname "$SUPERSET_LASTNAME" \
    --email "$SUPERSET_EMAIL" \
    --password "$SUPERSET_PASSWORD"
superset init

# 4. Mantém o container ativo
echo "✅ Superset rodando em http://localhost:8088"
superset run -p 8088 -h 0.0.0.0
