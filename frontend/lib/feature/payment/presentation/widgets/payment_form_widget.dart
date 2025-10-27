import 'package:design_alma/utils/extensions.dart';
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
                    context.l10n.informationCard,
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
                label: context.l10n.numberCard,
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
                    return context.l10n.required;
                  }
                  final cleanValue = CardNumberFormatter.clean(value);
                  if (cleanValue.length < 13 || cleanValue.length > 19) {
                    return context.l10n.validation;
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
                      label: context.l10n.month,
                      hint: '12',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.required;
                        }
                        final month = int.tryParse(value);
                        if (month == null || month < 1 || month > 12) {
                          return context.l10n.validation;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PaymentInputField(
                      controller: widget.controller.expiryYearController,
                      label: context.l10n.year,
                      hint: '26',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.required;
                        }
                        final year = int.tryParse(value);
                        final currentYear = DateTime.now().year % 100;
                        if (year == null || year < currentYear) {
                          return context.l10n.validation;
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
                    return 'CVV ${context.l10n.required}';
                  }
                  if (value.length < 3 || value.length > 4) {
                    return 'CVV ${context.l10n.validation}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Nombre del titular
              PaymentInputField(
                controller: widget.controller.cardHolderNameController,
                label: context.l10n.nameHolder,
                icon: Icons.person_outline,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.l10n.required;
                  }
                  if (value.trim().length < 2) {
                    return context.l10n.veryShort;
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
