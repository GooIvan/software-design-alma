import 'package:flutter/material.dart';
import '../models/discount_code_model.dart';
import '../services/discount_code_service.dart';
import '../utils/extensions.dart';

class DiscountCodeWidget extends StatefulWidget {
  final Function(DiscountCode?) onDiscountApplied;
  final Function()? onDiscountRemoved;
  final double subtotal;
  final DiscountCode? currentDiscount;

  const DiscountCodeWidget({
    super.key,
    required this.onDiscountApplied,
    this.onDiscountRemoved,
    required this.subtotal,
    this.currentDiscount,
  });

  @override
  State<DiscountCodeWidget> createState() => _DiscountCodeWidgetState();
}

class _DiscountCodeWidgetState extends State<DiscountCodeWidget> {
  final TextEditingController _codeController = TextEditingController();
  final DiscountCodeService _discountService = DiscountCodeService();

  bool _isValidating = false;
  String? _errorMessage;
  DiscountCode? _appliedDiscount;

  @override
  void initState() {
    super.initState();
    _appliedDiscount = widget.currentDiscount;
    if (_appliedDiscount != null) {
      _codeController.text = _appliedDiscount!.code;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _validateAndApplyCode() async {
    final code = _discountService.normalizeCode(_codeController.text);

    if (code.isEmpty) {
      setState(() {
        _errorMessage = context.l10n.enterDiscountCodeMessage;
      });
      return;
    }

    if (!_discountService.isValidCodeFormat(code)) {
      setState(() {
        _errorMessage = context.l10n.invalidCodeFormat;
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
          widget.onDiscountApplied(_appliedDiscount);

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${context.l10n.discountApplied}: ${_appliedDiscount!.description}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          _appliedDiscount = null;
          _errorMessage = validation.message;
          widget.onDiscountApplied(null);
        }
      });
    } catch (e) {
      setState(() {
        _isValidating = false;
        _errorMessage = context.l10n.codeValidationError;
        _appliedDiscount = null;
      });
      widget.onDiscountApplied(null);
    }
  }

  void _removeDiscount() {
    setState(() {
      _appliedDiscount = null;
      _errorMessage = null;
      _codeController.clear();
    });

    widget.onDiscountApplied(null);
    if (widget.onDiscountRemoved != null) {
      widget.onDiscountRemoved!();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.discountRemoved),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_offer, size: 20),
                const SizedBox(width: 8),
                Text(
                  context.l10n.discountCodeTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_appliedDiscount == null) ...[
              // Campo de entrada para código
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codeController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: context.l10n.enterCode,
                        border: const OutlineInputBorder(),
                        errorText: _errorMessage,
                        suffixIcon: _isValidating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : null,
                      ),
                      onFieldSubmitted: (_) => _validateAndApplyCode(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isValidating ? null : _validateAndApplyCode,
                    child: _isValidating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(context.l10n.applyDiscountCode),
                  ),
                ],
              ),
            ] else ...[
              // Mostrar descuento aplicado
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(8),
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
                            context.l10n.appliedDiscountMessage(_appliedDiscount!.code),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            _appliedDiscount!.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade600,
                            ),
                          ),
                          if (_appliedDiscount!.discountAmount != null) ...[
                            Text(
                              context.l10n.discountValue(_discountService.formatCurrency(_appliedDiscount!.discountAmount!)),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _removeDiscount,
                      icon: const Icon(Icons.close),
                      color: Colors.red.shade600,
                      tooltip: context.l10n.removeDiscount,
                    ),
                  ],
                ),
              ),
            ],

            // Mensaje de ayuda
            if (_appliedDiscount == null && _errorMessage == null) ...[
              const SizedBox(height: 8),
              Text(
                context.l10n.discountInfo,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget más pequeño para mostrar descuento aplicado (solo lectura)
class AppliedDiscountDisplay extends StatelessWidget {
  final AppliedDiscount discount;
  final VoidCallback? onRemove;

  const AppliedDiscountDisplay({
    super.key,
    required this.discount,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (!discount.applied) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer, color: Colors.green.shade600, size: 16),
          const SizedBox(width: 6),
          Text(
            '${discount.code} (-${discount.formattedAmount})',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
              fontSize: 12,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close,
                size: 14,
                color: Colors.red.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget para mostrar lista de códigos disponibles
class AvailableDiscountCodes extends StatefulWidget {
  final Function(DiscountCode) onCodeSelected;

  const AvailableDiscountCodes({
    super.key,
    required this.onCodeSelected,
  });

  @override
  State<AvailableDiscountCodes> createState() => _AvailableDiscountCodesState();
}

class _AvailableDiscountCodesState extends State<AvailableDiscountCodes> {
  final DiscountCodeService _discountService = DiscountCodeService();
  List<DiscountCode> _availableCodes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableCodes();
  }

  Future<void> _loadAvailableCodes() async {
    try {
      final codes = await _discountService.getAvailableDiscountCodes();
      setState(() {
        _availableCodes = codes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_availableCodes.isEmpty) {
      return Center(
        child: Text(context.l10n.noDiscountCodesAvailable),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _availableCodes.length,
      itemBuilder: (context, index) {
        final code = _availableCodes[index];
        return ListTile(
          leading: Icon(
            Icons.local_offer,
            color: Colors.green.shade600,
          ),
          title: Text(
            code.code,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(code.description),
              if (code.expiresAt != null)
                Text(
                  context.l10n.expireDate('${code.expiresAt!.day}/${code.expiresAt!.month}/${code.expiresAt!.year}'),
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
          trailing: ElevatedButton(
            onPressed: () => widget.onCodeSelected(code),
            child: Text(context.l10n.useDiscountCode),
          ),
        );
      },
    );
  }
}
