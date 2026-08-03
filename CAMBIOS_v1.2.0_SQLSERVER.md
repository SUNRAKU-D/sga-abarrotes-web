# Cambios de SGA v1.2.0 SQL Server

## Eliminación de datos experimentales

Se eliminaron del código fuente:

- `src/lib/mockData.ts`
- `src/lib/demoStore.ts`
- `src/lib/businessStore.ts`
- el antiguo `src/lib/db.ts` de usuarios simulados
- todas las lecturas y escrituras de `localStorage`
- las cuentas y contraseñas de demostración
- la función de restablecer datos de prueba

## Persistencia real

Se añadieron:

- pool de conexión privado con `mssql`;
- variables de entorno privadas;
- API para autenticación, empresa, catálogos, productos, inventario, caja, ventas, clientes, proveedores, compras, devoluciones, créditos, reportes, auditoría y usuarios;
- transacciones para operaciones de ventas, compras y anulación;
- sesiones firmadas en cookie HttpOnly;
- contraseñas bcrypt y bloqueo tras intentos fallidos;
- validación de permisos en servidor;
- auditoría de acciones críticas.

## Migración complementaria

La migración crea tablas necesarias para funciones que no existían en la estructura original:

- `auditoria`
- `movimientos_caja`
- `ventas_pagos`
- `ventas_detalle_manual`
- `ventas_suspendidas`
- `ventas_suspendidas_detalle`

También amplía `usuarios` con bloqueo e intentos fallidos.

## Mejoras funcionales

- POS con datos reales, stock real y series reales.
- Pago múltiple y crédito.
- Venta manual sin modificar inventario.
- Suspensión persistente de carritos.
- Caja con movimientos y arqueo.
- Compras que activan triggers de stock.
- Devoluciones mediante `sp_registrar_devolucion`.
- Pagos mediante `sp_registrar_pago_credito`.
- Ajustes mediante `sp_ajustar_stock`.
- Reportes desde vistas de SQL Server.
- Administración real de usuarios y empresa.

## Correcciones técnicas

- Los parámetros enviados a procedimientos almacenados usan sus nombres exactos.
- El IGV de compras se deriva de la tasa configurada y de la condición tributaria del producto, sin agregar 18 % dos veces.
- Las respuestas de sesión inválida devuelven HTTP 401.
- La configuración de conexión se carga de forma diferida, evitando exponer secretos en el cliente.
