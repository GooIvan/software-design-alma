import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CartSummaryWidget extends StatefulWidget {
  final double subtotal;
  final double tax;
  final double discount;
  final double total;

  const CartSummaryWidget({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
  });

  @override
  State<CartSummaryWidget> createState() => _CartSummaryWidgetState();
}

class _CartSummaryWidgetState extends State<CartSummaryWidget> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'es_CO');
    return '\$${formatter.format(amount.round())}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Campo de código promocional
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor ??
                          Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promoController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10)
                            ],
                            decoration: InputDecoration(
                              hintText: context.l10n.enterCodePromocional,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: InputBorder.none, // sin bordes
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_promoController.text.isNotEmpty) {
                              // acción del botón
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            context.l10n.apply,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Resumen de costos
            Column(
              children: [
                _buildSummaryRow(
                    context.l10n.quantity, _formatCurrency(widget.subtotal)),
                const SizedBox(height: 8),
                _buildSummaryRow(
                    context.l10n.taxRate, _formatCurrency(widget.tax)),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  context.l10n.discount,
                  '-${_formatCurrency(widget.discount)}',
                  isDiscount: true,
                ),
                const SizedBox(height: 16),
                _buildSummaryRow(
                  context.l10n.total,
                  _formatCurrency(widget.total),
                  isTotal: true,
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildSummaryRow(String label, String amount,
      {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
            color: isTotal
                ? Theme.of(context).textTheme.displayLarge?.color
                : Colors.grey[600],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
            color: isDiscount
                ? Theme.of(context).colorScheme.primary
                : isTotal
                    ? Theme.of(context).textTheme.displayLarge?.color
                    : Theme.of(context).textTheme.displayLarge?.color,
          ),
        ),
      ],
    );
  }
}
