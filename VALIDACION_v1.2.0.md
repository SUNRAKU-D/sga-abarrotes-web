# Validación técnica v1.2.0

## Ejecutado en el entorno de revisión

```text
npm run type-check
```

Resultado: correcto, sin errores de TypeScript.

## Revisión estática

- No quedan importaciones de los almacenes de demostración.
- No quedan operaciones con `localStorage` ni `sessionStorage`.
- No se incluyó `.env.local` ni la contraseña real de SQL Server.
- Las rutas API se ejecutan con runtime Node.js.
- Los procedimientos `sp_ajustar_stock`, `sp_registrar_devolucion` y `sp_registrar_pago_credito` reciben parámetros con los nombres definidos en la base.
- Las operaciones de venta, compra y anulación están encapsuladas en transacciones.

## Compilación de producción

La compilación no pudo finalizar en el contenedor de revisión porque no estaba instalado el binario SWC de Next.js para Linux. En el equipo del usuario, después de `npm install`, debe ejecutarse:

```bash
npm run type-check
npm run build
```

## Prueba pendiente en el equipo del usuario

No fue posible abrir una conexión real a `DESKTOP-2CTLF87\\SQLEXPRESS` desde este entorno, porque esa instancia solo existe en la red local del usuario. La conexión debe comprobarse con:

```bash
npm run verify-db
npm run dev
```
