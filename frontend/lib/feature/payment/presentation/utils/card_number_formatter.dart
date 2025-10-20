class CardNumberFormatter {
  static String format(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  static String clean(String value) {
    return value.replaceAll(' ', '');
  }
}
