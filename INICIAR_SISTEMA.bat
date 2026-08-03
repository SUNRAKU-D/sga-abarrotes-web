@echo off
setlocal
cd /d "%~dp0"
title SGA Abarrotes Web v1.2.0 SQL Server

echo ==============================================
echo   SGA ABARROTES WEB - SQL SERVER
echo ==============================================

where node >nul 2>&1
if errorlevel 1 (
  echo ERROR: Node.js no esta instalado.
  pause
  exit /b 1
)

if not exist .env.local (
  echo ERROR: falta el archivo .env.local.
  echo Copia .env.example, renombralo a .env.local y configura SQL Server.
  pause
  exit /b 1
)

if not exist node_modules (
  echo Instalando dependencias...
  call npm install
  if errorlevel 1 (
    echo No se pudieron instalar las dependencias.
    pause
    exit /b 1
  )
)

echo Verificando tipos...
call npm run type-check
if errorlevel 1 (
  echo Corrige los errores antes de iniciar.
  pause
  exit /b 1
)

echo URL: http://localhost:4028
start "" http://localhost:4028
call npm run dev
pause
