import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  // final RegExp _exp = RegExp(r'^\d*\.?\d*');
  final RegExp _exp = RegExp(r'^\d*\.?\d*$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text == '') {
      return newValue.copyWith(text: '');
    } else if (_exp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}