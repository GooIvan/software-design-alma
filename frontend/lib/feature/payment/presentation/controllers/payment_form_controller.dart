import 'package:flutter/widgets.dart';
import '../../../../models/payment_model.dart';
import '../utils/card_number_formatter.dart';

class PaymentFormController {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();

  // Getters para acceder a los controladores
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get cardNumberController => _cardNumberController;
  TextEditingController get expiryMonthController => _expiryMonthController;
  TextEditingController get expiryYearController => _expiryYearController;
  TextEditingController get cvvController => _cvvController;
  TextEditingController get cardHolderNameController =>
      _cardHolderNameController;

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  CardData getCardData() {
    return CardData(
      cardNumber: CardNumberFormatter.clean(_cardNumberController.text),
      expirationDate:
          '${_expiryMonthController.text}${_expiryYearController.text}',
      cvv: _cvvController.text,
      cardholderName: _cardHolderNameController.text,
    );
  }

  void dispose() {
    _cardNumberController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    _cvvController.dispose();
    _cardHolderNameController.dispose();
  }
}
