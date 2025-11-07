import 'package:equatable/equatable.dart';

class DiscountCode extends Equatable {
  final String code;
  final String discountType; // 'percentage' o 'fixed_amount'
  final double value;
  final String description;
  final DateTime? expiresAt;
  final bool userSpecific;
  final int? remainingUses;
  final double? discountAmount; // Calculado para un subtotal específico

  const DiscountCode({
    required this.code,
    required this.discountType,
    required this.value,
    required this.description,
    this.expiresAt,
    this.userSpecific = false,
    this.remainingUses,
    this.discountAmount,
  });

  /// Crear desde JSON de la API
  factory DiscountCode.fromJson(Map<String, dynamic> json) {
    return DiscountCode(
      code: json['code']?.toString() ?? '',
      discountType: json['discount_type']?.toString() ?? 'percentage',
      value: _parseDouble(json['value']),
      description: json['description']?.toString() ?? '',
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'].toString())
          : null,
      userSpecific: json['user_specific'] == true,
      remainingUses: _parseInt(json['remaining_uses']),
      discountAmount: _parseDouble(json['discount_amount']),
    );
  }

  /// Helper para parsear valores double de forma segura
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  /// Helper para parsear valores int de forma segura
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount_type': discountType,
      'value': value,
      'description': description,
      'expires_at': expiresAt?.toIso8601String(),
      'user_specific': userSpecific,
      'remaining_uses': remainingUses,
      'discount_amount': discountAmount,
    };
  }

  /// Crear copia con modificaciones
  DiscountCode copyWith({
    String? code,
    String? discountType,
    double? value,
    String? description,
    DateTime? expiresAt,
    bool? userSpecific,
    int? remainingUses,
    double? discountAmount,
  }) {
    return DiscountCode(
      code: code ?? this.code,
      discountType: discountType ?? this.discountType,
      value: value ?? this.value,
      description: description ?? this.description,
      expiresAt: expiresAt ?? this.expiresAt,
      userSpecific: userSpecific ?? this.userSpecific,
      remainingUses: remainingUses ?? this.remainingUses,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }

  /// Verificar si es un descuento por porcentaje
  bool get isPercentage => discountType == 'percentage';

  /// Verificar si es un descuento por cantidad fija
  bool get isFixedAmount => discountType == 'fixed_amount';

  /// Verificar si el código ha expirado
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Verificar si tiene usos restantes
  bool get hasRemainingUses {
    if (remainingUses == null) return true; // Sin límite
    return remainingUses! > 0;
  }

  /// Verificar si el código es válido para usar
  bool get isValid {
    return !isExpired && hasRemainingUses;
  }

  /// Calcular el descuento para un subtotal dado
  double calculateDiscount(double subtotal) {
    if (!isValid || subtotal <= 0) return 0.0;

    if (isPercentage) {
      return subtotal * (value / 100.0);
    } else {
      // Para cantidad fija, no puede exceder el subtotal
      return value > subtotal ? subtotal : value;
    }
  }

  /// Calcula el total con descuento aplicado
  double calculateDiscountedTotal(double originalTotal) {
    if (!isValid || originalTotal <= 0) return originalTotal;

    final discount = calculateDiscount(originalTotal);
    return originalTotal - discount;
  }

  /// Obtener texto formateado del valor del descuento
  String get formattedValue {
    if (isPercentage) {
      return '${value.toStringAsFixed(0)}%';
    } else {
      return '\$${value.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}';
    }
  }

  /// Obtener texto del tipo de descuento
  String get discountTypeLabel {
    switch (discountType) {
      case 'percentage':
        return 'Porcentaje';
      case 'fixed_amount':
        return 'Cantidad fija';
      default:
        return 'Desconocido';
    }
  }

  @override
  List<Object?> get props => [
        code,
        discountType,
        value,
        description,
        expiresAt,
        userSpecific,
        remainingUses,
        discountAmount,
      ];

  @override
  String toString() {
    return 'DiscountCode(code: $code, type: $discountType, value: $value, valid: $isValid)';
  }
}

/// Modelo para la respuesta de validación de código de descuento
class DiscountCodeValidation extends Equatable {
  final bool success;
  final bool valid;
  final String message;
  final DiscountCode? discountCode;
  final double? appliedAmount;

  const DiscountCodeValidation({
    required this.success,
    required this.valid,
    required this.message,
    this.discountCode,
    this.appliedAmount,
  });

  factory DiscountCodeValidation.fromJson(Map<String, dynamic> json) {
    return DiscountCodeValidation(
      success: json['success'] == true,
      valid: json['valid'] == true,
      message: json['message']?.toString() ?? '',
      discountCode: json['discount_code'] != null
          ? DiscountCode.fromJson(json['discount_code'])
          : null,
      appliedAmount: DiscountCode._parseDouble(json['applied_amount']),
    );
  }

  @override
  List<Object?> get props =>
      [success, valid, message, discountCode, appliedAmount];
}

/// Modelo para descuentos aplicados en órdenes
class AppliedDiscount extends Equatable {
  final String code;
  final String discountType;
  final double discountValue;
  final double appliedAmount;
  final bool applied;

  const AppliedDiscount({
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.appliedAmount,
    this.applied = true,
  });

  factory AppliedDiscount.fromJson(Map<String, dynamic> json) {
    return AppliedDiscount(
      code: json['code']?.toString() ?? '',
      discountType: json['discount_type']?.toString() ?? 'percentage',
      discountValue: DiscountCode._parseDouble(json['discount_value']),
      appliedAmount: DiscountCode._parseDouble(json['applied_amount']),
      applied: json['applied'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount_type': discountType,
      'discount_value': discountValue,
      'applied_amount': appliedAmount,
      'applied': applied,
    };
  }

  String get formattedAmount {
    return '\$${appliedAmount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  @override
  List<Object?> get props => [
        code,
        discountType,
        discountValue,
        appliedAmount,
        applied,
      ];
}
