# SGA Abarrotes Web v1.2.0 — SQL Server

Sistema web de gestión para tienda de abarrotes conectado a Microsoft SQL Server. Esta versión elimina los datos experimentales del navegador: ventas, productos, stock, clientes, caja, compras, devoluciones, créditos, reportes, usuarios y auditoría se consultan o registran mediante rutas API del servidor.

## Arquitectura

```text
Navegador (Next.js/React)
        ↓ HTTPS/HTTP
Route Handlers /api (Node.js)
        ↓ node-mssql
DESKTOP-2CTLF87\SQLEXPRESS
        ↓
abarrotes_pos
```

El navegador nunca recibe la contraseña de SQL Server ni se conecta directamente a la base.

## Requisitos

- Node.js 20.9 o superior.
- SQL Server Express en `DESKTOP-2CTLF87\SQLEXPRESS`.
- Base `abarrotes_pos` con la estructura original instalada.
- TCP/IP habilitado para `SQLEXPRESS`.
- Autenticación mixta si se usa el login `sga_app`.

## Instalación resumida

1. Cambia la contraseña de `sga_app` porque la anterior fue compartida en el chat.
2. Copia `.env.example` como `.env.local` y coloca la nueva contraseña.
3. Ejecuta en SQL Server, en este orden:
   - `database/01_migracion_integracion_web.sql`
   - genera un hash con `npm run hash-password -- "TU_CLAVE"`
   - edita y ejecuta `database/02_crear_primer_admin.sql`
   - `database/04_roles_y_permisos_recomendados.sql`
   - inyecta tus datos operativos reales cuando estén listos
   - `database/03_verificar_integracion.sql`
4. En la terminal:

```bash
npm install
npm run type-check
npm run verify-db
npm run dev
```

5. Abre `http://localhost:4028`.

La guía completa está en [INTEGRACION_SQL_SERVER.md](INTEGRACION_SQL_SERVER.md).

## Módulos conectados

- Autenticación con contraseña bcrypt, sesión firmada HttpOnly y bloqueo por intentos.
- Dashboard.
- POS, ventas manuales, pago múltiple, venta al crédito y ventas suspendidas.
- Historial, detalle, reimpresión y anulación de ventas.
- Caja, turnos, ingresos, egresos y arqueo.
- Productos, stock, ajustes, kardex, lotes y vencimientos.
- Proveedores, compras y actualización de stock/costo.
- Clientes.
- Devoluciones, nota de crédito y vale de canje según los procedimientos existentes.
- Créditos, pagos parciales y vencimientos.
- Reportes exportables a CSV para Excel e impresión/PDF.
- Usuarios, roles, configuración de empresa y auditoría.

## Seguridad

- No existe `.env.local` dentro del paquete.
- No hay credenciales de demostración.
- Las contraseñas de usuarios se guardan como hashes bcrypt.
- Las variables de base no usan el prefijo `NEXT_PUBLIC_`.
- Las operaciones críticas se validan también en el servidor.

## Base inicialmente vacía

El sistema mostrará estados vacíos hasta que existan datos reales. Para iniciar sesión se necesita al menos el primer administrador. Para operar el POS se requieren empresa, almacén, caja, comprobantes, series, formas de pago, categorías, unidades, productos y stock.
