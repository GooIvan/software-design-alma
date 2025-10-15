import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/payment_input_field.dart';
import '../utils/card_number_formatter.dart';
import '../controllers/payment_form_controller.dart';

class PaymentFormWidget extends StatefulWidget {
  final PaymentFormController controller;

  const PaymentFormWidget({
    super.key,
    required this.controller,
  });

  @override
  State<PaymentFormWidget> createState() => _PaymentFormWidgetState();
}

class _PaymentFormWidgetState extends State<PaymentFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: widget.controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la sección
              Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    'Información de la Tarjeta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Número de tarjeta
              PaymentInputField(
                controller: widget.controller.cardNumberController,
                label: 'Número de tarjeta',
                hint: '4111 1111 1111 1111',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                ],
                onChanged: (value) {
                  final formatted = CardNumberFormatter.format(value);
                  if (formatted != value) {
                    widget.controller.cardNumberController.value =
                        TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el número de tarjeta';
                  }
                  final cleanValue = CardNumberFormatter.clean(value);
                  if (cleanValue.length < 13 || cleanValue.length > 19) {
                    return 'Número de tarjeta inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Mes y año de expiración
              Row(
                children: [
                  Expanded(
                    child: PaymentInputField(
                      controller: widget.controller.expiryMonthController,
                      label: 'Mes',
                      hint: '12',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final month = int.tryParse(value);
                        if (month == null || month < 1 || month > 12) {
                          return 'Inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PaymentInputField(
                      controller: widget.controller.expiryYearController,
                      label: 'Año',
                      hint: '26',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        final year = int.tryParse(value);
                        final currentYear = DateTime.now().year % 100;
                        if (year == null || year < currentYear) {
                          return 'Inválido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // CVV
              PaymentInputField(
                controller: widget.controller.cvvController,
                label: 'CVV',
                hint: '123',
                icon: Icons.lock_outline,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CVV requerido';
                  }
                  if (value.length < 3 || value.length > 4) {
                    return 'CVV inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Nombre del titular
              PaymentInputField(
                controller: widget.controller.cardHolderNameController,
                label: 'Nombre del titular',
                icon: Icons.person_outline,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nombre requerido';
                  }
                  if (value.trim().length < 2) {
                    return 'Muy corto';
                  }
                  return null;
                },
                hint: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
