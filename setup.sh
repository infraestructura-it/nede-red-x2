#!/bin/bash

echo "🚀 Bienvenido al instalador interactivo de Node-RED"

# Preguntar antes de crear carpetas
read -p "👉 ¿Querés crear la estructura del proyecto (carpetas y archivos)? [s/N]: " crear
if [[ "$crear" =~ ^[sS]$ ]]; then
  mkdir -p nodered-flujos/.node-red
  mkdir -p nodered-flujos/.devcontainer
  cd nodered-flujos || exit 1

  echo "📄 Creando README.md..."
  cat <<EOF > README.md
# Proyecto Node-RED

Este proyecto contiene flujos y configuración de Node-RED para usar localmente o en GitHub Codespaces.
EOF

  echo "📄 Creando flows.json de ejemplo..."
  cat <<EOF > flows.json
[
  {
    "id": "inject1",
    "type": "inject",
    "name": "Hola Mundo",
    "props": [],
    "repeat": "",
    "crontab": "",
    "once": true,
    "onceDelay": 0.1,
    "wires": [["debug1"]]
  },
  {
    "id": "debug1",
    "type": "debug",
    "name": "Salida",
    "active": true,
    "tosidebar": true,
    "wires": []
  }
]
EOF

  echo "📄 Creando .gitignore..."
  cat <<EOF > .gitignore
node_modules/
.npm/
*.log
EOF

  echo "📄 Creando .devcontainer/devcontainer.json..."
  cat <<EOF > .devcontainer/devcontainer.json
{
  "name": "Node-RED Dev",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "18"
    }
  },
  "postCreateCommand": "./setup.sh"
}
EOF

  cd ..
else
  echo "❌ Salteando creación de estructura."
fi

# Confirmar instalación de Node-RED
read -p "👉 ¿Querés instalar Node-RED globalmente con npm? [s/N]: " instalar
if [[ "$instalar" =~ ^[sS]$ ]]; then
  echo "📦 Instalando Node-RED..."
  npm install -g --unsafe-perm node-red
else
  echo "❌ Node-RED no será instalado."
fi

# Confirmar copiar el flujo a ~/.node-red
read -p "👉 ¿Querés copiar el flujo de ejemplo a ~/.node-red/flows.json? [s/N]: " copiar
if [[ "$copiar" =~ ^[sS]$ ]]; then
  echo "📁 Copiando flujo..."
  mkdir -p ~/.node-red
  cp nodered-flujos/flows.json ~/.node-red/flows.json
else
  echo "❌ No se copiará el flujo."
fi

# Confirmar inicializar repo Git
read -p "👉 ¿Querés inicializar repositorio Git localmente? [s/N]: " gitinit
if [[ "$gitinit" =~ ^[sS]$ ]]; then
  cd nodered-flujos || exit 1
  git init
  git add .
  git commit -m "🚀 Proyecto inicial de Node-RED"
else
  echo "❌ No se inicializa Git."
fi

echo "✅ Proceso finalizado. Ejecutá 'node-red' para iniciar si lo instalaste."
