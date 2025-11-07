import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../models/discount_code_model.dart';
import '../../../../services/discount_code_service.dart';

class CartSummaryWidget extends StatefulWidget {
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final Function(DiscountCode?)? onDiscountApplied;
  final DiscountCode? currentDiscountCode;

  const CartSummaryWidget({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    this.onDiscountApplied,
    this.currentDiscountCode,
  });

  @override
  State<CartSummaryWidget> createState() => _CartSummaryWidgetState();
}

class _CartSummaryWidgetState extends State<CartSummaryWidget> {
  final TextEditingController _promoController = TextEditingController();
  final DiscountCodeService _discountService = DiscountCodeService();

  bool _isValidating = false;
  String? _errorMessage;
  DiscountCode? _appliedDiscount;

  @override
  void initState() {
    super.initState();
    _appliedDiscount = widget.currentDiscountCode;
    if (_appliedDiscount != null) {
      _promoController.text = _appliedDiscount!.code;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'es_CO');
    return '\$${formatter.format(amount.round())}';
  }

  Future<void> _validateAndApplyDiscount() async {
    final code = _discountService.normalizeCode(_promoController.text);

    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Ingresa un código de descuento';
      });
      return;
    }

    if (!_discountService.isValidCodeFormat(code)) {
      setState(() {
        _errorMessage = 'Formato de código inválido';
      });
      return;
    }

    setState(() {
      _isValidating = true;
      _errorMessage = null;
    });

    try {
      final validation = await _discountService.validateDiscountCode(
        code,
        subtotal: widget.subtotal,
      );

      setState(() {
        _isValidating = false;

        if (validation.success && validation.valid) {
          _appliedDiscount = validation.discountCode;
          _errorMessage = null;

          // Notificar al padre sobre el descuento aplicado
          if (widget.onDiscountApplied != null) {
            widget.onDiscountApplied!(_appliedDiscount);
          }

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Descuento aplicado: ${_appliedDiscount!.description}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          _appliedDiscount = null;
          _errorMessage = validation.message;

          if (widget.onDiscountApplied != null) {
            widget.onDiscountApplied!(null);
          }
        }
      });
    } catch (e) {
      setState(() {
        _isValidating = false;
        _errorMessage = 'Error al validar código';
        _appliedDiscount = null;
      });

      if (widget.onDiscountApplied != null) {
        widget.onDiscountApplied!(null);
      }
    }
  }

  void _removeDiscount() {
    setState(() {
      _appliedDiscount = null;
      _errorMessage = null;
      _promoController.clear();
    });

    if (widget.onDiscountApplied != null) {
      widget.onDiscountApplied!(null);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Descuento removido'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
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
            // Campo de código promocional mejorado
            const SizedBox(height: 12),

            if (_appliedDiscount == null) ...[
              // Mostrar campo de entrada cuando no hay descuento aplicado
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor ??
                            Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: _errorMessage != null
                            ? Border.all(color: Colors.red, width: 1)
                            : null,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20)
                              ],
                              decoration: InputDecoration(
                                hintText: context.l10n.enterCodePromocional,
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                border: InputBorder.none,
                                errorText: null, // No mostrar error aquí
                              ),
                              onSubmitted: (_) => _validateAndApplyDiscount(),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isValidating
                                ? null
                                : _validateAndApplyDiscount,
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
                            child: _isValidating
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
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

              // Mostrar mensaje de error si existe
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.red.shade600, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ] else ...[
              // Mostrar descuento aplicado
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.green.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Código aplicado: ${_appliedDiscount!.code}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _appliedDiscount!.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _removeDiscount,
                      icon: const Icon(Icons.close, size: 20),
                      color: Colors.red.shade600,
                      tooltip: 'Quitar descuento',
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Resumen de costos actualizado
            Column(
              children: [
                _buildSummaryRow(
                    context.l10n.quantity, _formatCurrency(widget.subtotal)),
                const SizedBox(height: 8),
                _buildSummaryRow(
                    context.l10n.taxRate, _formatCurrency(widget.tax)),
                const SizedBox(height: 8),

                // Mostrar descuento si aplica
                if (_appliedDiscount != null) ...[
                  _buildSummaryRow(
                    'Descuento (${_appliedDiscount!.code})',
                    '-${_formatCurrency(_appliedDiscount!.calculateDiscount(widget.subtotal))}',
                    isDiscount: true,
                  ),
                  const SizedBox(height: 8),
                ] else ...[
                  _buildSummaryRow(
                    context.l10n.discount,
                    '-${_formatCurrency(widget.discount)}',
                    isDiscount: true,
                  ),
                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 16),
                _buildSummaryRow(
                  context.l10n.total,
                  _formatCurrency(_calculateFinalTotal()),
                  isTotal: true,
                ),
              ],
            ),
          ],
        ));
  }

  double _calculateFinalTotal() {
    double total = widget.subtotal + widget.tax;

    if (_appliedDiscount != null) {
      final discountAmount =
          _appliedDiscount!.calculateDiscount(widget.subtotal);
      total = total - discountAmount;
    } else {
      total = total -
          widget.discount; // Descuento original si no hay código aplicado
    }

    return total > 0 ? total : 0; // Evitar totales negativos
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
