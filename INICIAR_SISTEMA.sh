#!/usr/bin/env sh
set -e
cd "$(dirname "$0")"
command -v node >/dev/null 2>&1 || { echo "Node.js no está instalado."; exit 1; }
[ -f .env.local ] || { echo "Falta .env.local. Copia y configura .env.example."; exit 1; }
[ -d node_modules ] || npm install
npm run type-check
printf '%s\n' "Sistema: http://localhost:4028"
npm run dev
