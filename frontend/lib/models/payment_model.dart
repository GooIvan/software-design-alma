class PaymentResponse {
  final bool success;
  final String message;
  final String? transactionId;
  final String? payuReference;
  final String? payuOrderId;
  final PaymentOrder? order;
  final String? errorCode;
  final String? payuError;

  PaymentResponse({
    required this.success,
    required this.message,
    this.transactionId,
    this.payuReference,
    this.payuOrderId,
    this.order,
    this.errorCode,
    this.payuError,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'] is bool
          ? json['success']
          : json['success'] == true || json['success'] == 'true',
      message: json['message']?.toString() ?? '',
      transactionId: json['transaction_id']?.toString(),
      payuReference: json['payu_reference']?.toString(),
      payuOrderId: json['payu_order_id']?.toString(),
      order:
          json['order'] != null ? PaymentOrder.fromJson(json['order']) : null,
      errorCode: json['error_code']?.toString(),
      payuError: json['payu_error']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'transaction_id': transactionId,
      'payu_reference': payuReference,
      'payu_order_id': payuOrderId,
      'order': order?.toJson(),
      'error_code': errorCode,
      'payu_error': payuError,
    };
  }
}

class PaymentOrder {
  final int id;
  final String status;
  final double total;
  final String? currency;

  PaymentOrder({
    required this.id,
    required this.status,
    required this.total,
    this.currency,
  });

  factory PaymentOrder.fromJson(Map<String, dynamic> json) {
    try {
      final id = _parseInt(json['id']);
      final status = json['status']?.toString() ?? '';
      final total = _parseDouble(json['total']);
      final currency = json['currency']?.toString();

      return PaymentOrder(
        id: id,
        status: status,
        total: total,
        currency: currency,
      );
    } catch (e) {
      rethrow;
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value) ?? 0.0;
      return parsed;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'total': total,
      'currency': currency,
    };
  }
}

class PaymentStatusResponse {
  final bool success;
  final String message;
  final PaymentOrder? order;
  final String? paymentStatus;
  final String? transactionId;

  PaymentStatusResponse({
    required this.success,
    required this.message,
    this.order,
    this.paymentStatus,
    this.transactionId,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      success: json['success'] is bool
          ? json['success']
          : json['success'] == true || json['success'] == 'true',
      message: json['message']?.toString() ?? '',
      order:
          json['order'] != null ? PaymentOrder.fromJson(json['order']) : null,
      paymentStatus: json['payment_status']?.toString(),
      transactionId: json['transaction_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'order': order?.toJson(),
      'payment_status': paymentStatus,
      'transaction_id': transactionId,
    };
  }
}

class CardData {
  final String cardNumber;
  final String expirationDate;
  final String cvv;
  final String cardholderName;

  CardData({
    required this.cardNumber,
    required this.expirationDate,
    required this.cvv,
    required this.cardholderName,
  });

  Map<String, dynamic> toJson() {
    return {
      'card_number': cardNumber,
      'expiration_date': expirationDate,
      'cvv': cvv,
      'cardholder_name': cardholderName,
    };
  }

  // Método para limpiar el número de tarjeta
  String get cleanCardNumber => cardNumber.replaceAll(' ', '');

  // Método para validar datos básicos
  bool get isValid {
    return cleanCardNumber.length >= 13 &&
        cleanCardNumber.length <= 19 &&
        expirationDate.length == 4 &&
        cvv.length >= 3 &&
        cvv.length <= 4 &&
        cardholderName.trim().length >= 2;
  }
}
