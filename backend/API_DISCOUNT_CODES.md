# API Endpoints for Discount Codes

## Overview

This document describes the available API endpoints for managing discount codes in the application.

## Endpoints

### 1. Validate Discount Code

**POST** `/api/discount_codes/validate`

Validates a discount code and optionally calculates the discount amount.

#### Request Body

```json
{
  "code": "WESTCOL",
  "subtotal": 25000 // Optional: for calculating discount amount
}
```

#### Response (Success)

```json
{
  "success": true,
  "message": "Código de descuento válido",
  "valid": true,
  "discount_code": {
    "code": "WESTCOL",
    "discount_type": "fixed_amount",
    "value": 10000.0,
    "description": "$10000 de descuento",
    "discount_amount": 10000.0,
    "remaining_uses": 1,
    "expires_at": null
  }
}
```

#### Response (Error)

```json
{
  "success": false,
  "message": "El código de descuento ha expirado",
  "valid": false
}
```

### 2. Get Available Discount Codes

**GET** `/api/discount_codes/available`

Returns all active discount codes available for the current user.

#### Response

```json
{
  "success": true,
  "discount_codes": [
    {
      "code": "WESTCOL",
      "discount_type": "fixed_amount",
      "value": 10000.0,
      "description": "$10000 de descuento",
      "expires_at": null,
      "user_specific": false
    },
    {
      "code": "VERANO",
      "discount_type": "percentage",
      "value": 50.0,
      "description": "50% de descuento",
      "expires_at": "2025-12-31T23:59:59.000Z",
      "user_specific": false
    }
  ]
}
```

### 3. Create Order with Discount

**POST** `/api/orders`

Creates a new order and optionally applies a discount code.

#### Request Body

```json
{
  "items": [
    {
      "product_id": 1,
      "quantity": 2,
      "size": "M"
    }
  ],
  "discount_code": "WESTCOL" // Optional
}
```

#### Response

```json
{
  "success": true,
  "message": "Orden creada exitosamente",
  "order": {
    "id": 123,
    "order_number": "ORD-00000123",
    "status": "pending",
    "subtotal": 25000,
    "discount": {
      "code": "WESTCOL",
      "amount": 10000,
      "applied": true,
      "discount_type": "fixed_amount",
      "discount_value": 10000
    },
    "total": 15000,
    "final_total": 15000,
    "created_at": "2025-11-07T16:00:00.000Z",
    "updated_at": "2025-11-07T16:00:00.000Z",
    "order_items": [...]
  }
}
```

### 4. Get Order Details (Updated)

**GET** `/api/orders/:id`

Returns detailed order information including discount details.

#### Response

```json
{
  "success": true,
  "order": {
    "id": 123,
    "order_number": "ORD-00000123",
    "status": "paid",
    "subtotal": 25000,
    "discount": {
      "code": "WESTCOL",
      "amount": 10000,
      "applied": true,
      "discount_type": "fixed_amount",
      "discount_value": 10000
    },
    "total": 15000,
    "final_total": 15000,
    "order_items": [...]
  }
}
```

### 5. Get Orders List (Updated)

**GET** `/api/orders`

Returns list of user's orders with discount information.

#### Response

```json
{
  "success": true,
  "orders": [
    {
      "id": 123,
      "order_number": "ORD-00000123",
      "status": "paid",
      "total": 15000,
      "subtotal": 25000,
      "discount": {
        "code": "WESTCOL",
        "amount": 10000,
        "applied": true
      },
      "items_count": 2,
      "created_at": "2025-11-07T16:00:00.000Z",
      "updated_at": "2025-11-07T16:00:00.000Z"
    }
  ]
}
```

### 6. Payment APIs (Updated)

All payment endpoints now include discount information in their responses.

## Error Codes

### Discount Code Validation Errors

- `DISCOUNT_CODE_NOT_FOUND` - The discount code doesn't exist
- `DISCOUNT_CODE_INACTIVE` - The discount code is not active
- `DISCOUNT_CODE_EXPIRED` - The discount code has expired
- `DISCOUNT_CODE_MAX_USES_REACHED` - The code has reached its maximum usage limit
- `DISCOUNT_CODE_USER_LIMIT_REACHED` - The user has reached their usage limit for this code
- `DISCOUNT_CODE_NOT_FOR_USER` - The code is exclusive to a different user

## Authentication

All endpoints require authentication via Bearer token in the Authorization header:

```
Authorization: Bearer <jwt_token>
```

## Rate Limiting

- Validation endpoint: 60 requests per minute per user
- Other endpoints: Follow standard API rate limits

## Testing

Use the following test codes:

- `WESTCOL`: $10,000 fixed discount
- `VERANO`: 50% percentage discount
- `SOLOPARACOLE`: 20% percentage discount (user-specific)
