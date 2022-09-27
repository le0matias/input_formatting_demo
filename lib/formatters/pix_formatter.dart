import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:input_formatting_demo/formatters/utils.dart';

class PixFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueLength = newValue.text.length;
    var selectionIndex = newValue.selection.end;
    var substrIndex = 0;
    final newText = StringBuffer();

    return textManipulation(
      oldValue,
      newValue,
      formatPattern: (String filteredString) {
        if (filteredString.length == 11 && CPFValidator.isValid(filteredString)) {
          filteredString = CPFValidator.format(filteredString);
          return filteredString;
        }
        if (filteredString.length == 11 && !CPFValidator.isValid(filteredString)) {
          if (newValueLength == 11) {
            if (newValue.text.toString()[2] != '9') {
              return oldValue.toString();
            }
          }

          /// Verifica o tamanho máximo do campo.
          if (newValueLength > 11) {
            return oldValue.toString();
          }
          if (newValueLength >= 1) {
            newText.write('(');
            if (newValue.selection.end >= 1) selectionIndex++;
          }

          if (newValueLength >= 3) {
            newText.write(newValue.text.substring(0, substrIndex = 2) + ') ');
            if (newValue.selection.end >= 2) selectionIndex += 2;
          }

          if (newValue.text.length == 11) {
            if (newValueLength >= 8) {
              newText.write(newValue.text.substring(2, substrIndex = 7) + '-');
              if (newValue.selection.end >= 7) selectionIndex++;
            }
          } else {
            if (newValueLength >= 7) {
              newText.write(newValue.text.substring(2, substrIndex = 6) + '-');
              if (newValue.selection.end >= 6) selectionIndex++;
            }
          }

          if (newValueLength >= substrIndex) {
            newText.write(newValue.text.substring(substrIndex));
          }

          return newText.toString();
        }
        return filteredString;
      },
    );
  }
}
