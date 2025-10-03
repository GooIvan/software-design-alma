# Guía Completa: Cómo Hacer Órdenes con API PayU

## 📋 **Introducción**

Esta guía te mostrará cómo usar las APIs para crear órdenes y procesar pagos con PayU. Incluye todos los escenarios posibles con ejemplos reales.

## 🔐 **1. Autenticación**

### Obtener Token JWT

```bash
curl -X POST http://localhost:3000/api/auth/users/sign_in \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "test@example.com",
      "password": "password123"
    }
  }'
```

### Respuesta:

```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 30,
    "email": "test@example.com",
    "name": "Juan",
    "last_name": "Pérez"
  }
}
```

**⚠️ Importante**: Guarda el token para usar en todas las siguientes peticiones.

---

## 🛒 **2. Crear Órdenes**

### Escenario 1: Orden Simple (Un Producto)

```bash
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TU_TOKEN_AQUI" \
  -d '{
    "items": [
      {
        "product_id": 49,
        "quantity": 1,
        "size": "M"
      }
    ]
  }'
```

### Escenario 2: Orden Múltiple (Varios Productos)

```bash
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TU_TOKEN_AQUI" \
  -d '{
    "items": [
      {
        "product_id": 49,
        "quantity": 2,
        "size": "M"
      },
      {
        "product_id": 50,
        "quantity": 1,
        "size": "L"
      },
      {
        "product_id": 51,
        "quantity": 3
      }
    ]
  }'
```

### Respuesta de Orden Creada:

```json
{
  "success": true,
  "message": "Orden creada exitosamente",
  "order": {
    "id": 151,
    "order_number": "ORD-00000151",
    "status": "pending",
    "status_display": "Pending",
    "total": "45000.0",
    "created_at": "2025-10-03T11:43:21-05:00",
    "updated_at": "2025-10-03T11:43:21-05:00",
    "order_items": [
      {
        "id": 153,
        "product_id": 49,
        "product_name": "Camiseta Negra",
        "size": "M",
        "quantity": 1,
        "price": "45000.0",
        "total_price": "45000.0",
        "product_image": "http://localhost:3000/rails/active_storage/..."
      }
    ]
  }
}
```

---

## 💳 **3. Procesar Pagos con PayU**

### Escenario 1: Pago Exitoso

```bash
curl -X POST http://localhost:3000/api/payments/process_payu_payment \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TU_TOKEN_AQUI" \
  -d '{
    "order_id": 151,
    "card_number": "4111111111111111",
    "expiration_date": "12/26",
    "cvv": "123",
    "cardholder_name": "Juan Pérez"
  }'
```

#### Respuesta Exitosa:

```json
{
  "success": true,
  "message": "Pago aprobado por PayU",
  "transaction_id": "6ac19101-a171-421f-a898-9b601fa5a587",
  "payu_reference": "151",
  "payu_order_id": "2155579195",
  "order": {
    "id": 151,
    "status": "paid",
    "total": "45000.0"
  }
}
```

### Escenario 2: Pago Rechazado

```bash
curl -X POST http://localhost:3000/api/payments/process_payu_payment \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TU_TOKEN_AQUI" \
  -d '{
    "order_id": 152,
    "card_number": "4000000000000002",
    "expiration_date": "12/26",
    "cvv": "123",
    "cardholder_name": "Juan Pérez"
  }'
```

#### Respuesta Rechazada:

```json
{
  "success": false,
  "message": "Transacción rechazada",
  "error_code": "INVALID_TRANSACTION",
  "payu_error": "DECLINED_BY_BANK",
  "order": {
    "id": 152,
    "status": "cancelled",
    "total": "45000.0"
  }
}
```

### Escenario 3: Error de Validación

```bash
curl -X POST http://localhost:3000/api/payments/process_payu_payment \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TU_TOKEN_AQUI" \
  -d '{
    "order_id": 153,
    "card_number": "1234",
    "expiration_date": "01/24",
    "cvv": "12",
    "cardholder_name": ""
  }'
```

#### Respuesta de Error:

```json
{
  "success": false,
  "message": "Número de tarjeta inválido",
  "error_code": "INVALID_CARD_NUMBER",
  "payu_error": null
}
```

---

## 📊 **4. Estados de Órdenes**

### Ver Estado Actual de una Orden

```bash
curl -X GET "http://localhost:3000/api/payments/payment_status?order_id=151" \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

### Estados Posibles:

| Estado      | Descripción                  | Cuándo Ocurre                       |
| ----------- | ---------------------------- | ----------------------------------- |
| `pending`   | Orden creada, esperando pago | Al crear la orden                   |
| `paid`      | Pago aprobado por PayU       | Pago exitoso                        |
| `cancelled` | Orden cancelada              | Pago rechazado o cancelación manual |

---

## 🔍 **5. Consultar Órdenes**

### Escenario 1: Ver Todas las Órdenes del Usuario

```bash
curl -X GET http://localhost:3000/api/orders \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

### Escenario 2: Ver Órdenes Activas (pending)

```bash
curl -X GET http://localhost:3000/api/orders/active \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

### Escenario 3: Ver Historial (cancelled/paid)

```bash
curl -X GET http://localhost:3000/api/orders/history \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

### Escenario 4: Ver Orden Específica

```bash
curl -X GET http://localhost:3000/api/orders/151 \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

---

## ❌ **6. Cancelar Órdenes**

### Cancelar Orden Pendiente

```bash
curl -X PATCH http://localhost:3000/api/orders/151/cancel \
  -H "Authorization: Bearer TU_TOKEN_AQUI"
```

**⚠️ Nota**: Solo se pueden cancelar órdenes con status `pending`.

---

## 🧪 **7. Tarjetas de Prueba PayU**

### Para Testing:

| Tarjeta        | Número             | Resultado         |
| -------------- | ------------------ | ----------------- |
| Visa Aprobada  | `4111111111111111` | ✅ Pago exitoso   |
| Visa Rechazada | `4000000000000002` | ❌ Pago rechazado |
| Mastercard     | `5555555555554444` | ✅ Pago exitoso   |
| Amex           | `378282246310005`  | ✅ Pago exitoso   |

### Datos Válidos:

- **Fecha**: `12/26` (cualquier fecha futura)
- **CVV**: `123` (3-4 dígitos)
- **Nombre**: Cualquier nombre

---


## ⚠️ **8. Errores Comunes**

### Error 401: Token Inválido

```json
{ "error": "Necesitas iniciar sesión o registrarte para continuar." }
```

**Solución**: Hacer login nuevamente y obtener token fresco.

### Error 404: Orden No Encontrada

```json
{ "success": false, "message": "Orden no encontrada" }
```

**Solución**: Verificar que el `order_id` sea correcto.

### Error 422: Datos Inválidos

```json
{
  "success": false,
  "message": "Faltan parámetros requeridos: card_number, cvv",
  "required_fields": [
    "card_number",
    "expiration_date",
    "cvv",
    "cardholder_name"
  ]
}
```

**Solución**: Enviar todos los campos requeridos.

---

## 🎯 **9. Mejores Prácticas**

1. **Siempre validar responses** antes de continuar
2. **Manejar errores** apropiadamente en la UI
3. **Guardar transaction_id** para referencias
4. **No reutilizar órdenes** después de pago fallido
5. **Verificar estados** antes de procesar pagos
6. **Usar HTTPS** en producción
7. **No logs de datos sensibles** (números de tarjeta)

---

¡Esta guía cubre todos los escenarios posibles para crear órdenes y procesar pagos con PayU! 🚀
