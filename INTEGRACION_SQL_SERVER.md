# Integración del SGA con SQL Server

## 1. Cambiar la contraseña expuesta

La contraseña que se escribió anteriormente en el chat no debe reutilizarse. En SQL Server Management Studio ejecuta:

```sql
USE [master];
GO
ALTER LOGIN [sga_app]
WITH PASSWORD = 'UNA_CLAVE_NUEVA_Y_UNICA';
GO
```

No compartas esa clave ni la guardes en Git.

## 2. Crear `.env.local`

En la carpeta que contiene `package.json` copia `.env.example` a `.env.local`:

```env
NEXT_PUBLIC_SITE_URL=http://localhost:4028
DB_SERVER=DESKTOP-2CTLF87
DB_INSTANCE=SQLEXPRESS
DB_PORT=
DB_DATABASE=abarrotes_pos
DB_USER=sga_app
DB_PASSWORD=TU_NUEVA_CLAVE
DB_ENCRYPT=false
DB_TRUST_SERVER_CERTIFICATE=true
DB_POOL_MAX=10
SESSION_SECRET=COLOCA_UN_VALOR_ALEATORIO_DE_MAS_DE_32_CARACTERES
SESSION_HOURS=8
```

`.gitignore` ya excluye los archivos `.env*`, salvo `.env.example`.

## 3. Instalar dependencias

```bash
npm install
```

Las dependencias nuevas son `mssql` para SQL Server y `bcryptjs` para las contraseñas de los usuarios.

## 4. Preparar la base

Ejecuta los archivos de `database` en este orden:

### 4.1 Migración web

```text
database/01_migracion_integracion_web.sql
```

Agrega, sin borrar la estructura original:

- bloqueo e intentos fallidos de usuarios;
- auditoría;
- ingresos y egresos de caja;
- pagos múltiples;
- líneas de venta manuales;
- ventas suspendidas.

### 4.2 Primer administrador

Genera un hash:

```bash
npm run hash-password -- "TU_CLAVE_DE_ACCESO_AL_SISTEMA"
```

Copia el resultado en `database/02_crear_primer_admin.sql`, cambia los datos personales y ejecútalo.

### 4.3 Roles y permisos

```text
database/04_roles_y_permisos_recomendados.sql
```

Configura ADMIN, CAJERO, ALMACENERO y SUPERVISOR con permisos acordes a las rutas del sistema.

### 4.4 Datos reales

La base está vacía. Inyecta o registra los datos reales cuando corresponda. El orden recomendado es:

1. Empresa.
2. Almacenes.
3. Cajas.
4. Unidades de medida.
5. Categorías y marcas.
6. Tipos y series de comprobante.
7. Formas de pago, incluyendo `CREDITO TIENDA` si habrá ventas al crédito.
8. Proveedores y clientes.
9. Productos.
10. Stock y lotes.

No ejecutes nuevamente el bloque antiguo de datos de demostración.

### 4.5 Verificación

```text
database/03_verificar_integracion.sql
```

## 5. Comprobar la conexión

```bash
npm run verify-db
```

También puedes iniciar el sistema y abrir:

```text
http://localhost:4028/api/health/db
```

Una respuesta correcta contiene `ok: true`, el servidor y `abarrotes_pos`.

## 6. Ejecutar

```bash
npm run dev
```

URL local:

```text
http://localhost:4028
```

Desde otro dispositivo de la misma red:

```text
http://IP_DE_TU_PC:4028
```

## 7. Flujo de datos

- El cliente React llama rutas `/api/...`.
- Las rutas validan la sesión y los permisos.
- El servidor usa un pool de conexiones `mssql`.
- Las ventas y compras usan transacciones.
- Los triggers originales actualizan inventario y kardex.
- Las credenciales de SQL Server solo existen en el servidor.

## 8. Problemas frecuentes

### No se encuentra la instancia

Comprueba que estén ejecutándose:

- `SQL Server (SQLEXPRESS)`
- `SQL Server Browser`

Y que TCP/IP esté habilitado en los protocolos de SQLEXPRESS.

### Login failed for user sga_app

Comprueba autenticación mixta, contraseña, asignación del usuario a `abarrotes_pos` y permisos sobre `dbo`.

### La pantalla dice que falta configuración

Ejecuta la migración y crea el primer administrador. Para el POS también deben existir catálogos, caja, serie y productos reales.
