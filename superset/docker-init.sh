#!/bin/bash

# Inicializa Superset
superset db upgrade
superset fab create-admin \
    --username admin \
    --firstname Caio \
    --lastname Moro \
    --email caio.moro@outlook.com \
    --password helena123
superset init

# Mantém o container rodando
superset run -p 8088 -h 0.0.0.0
