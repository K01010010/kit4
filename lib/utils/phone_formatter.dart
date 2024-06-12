part of '../kit4.dart';

class PhoneFormatterKit4 extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    var newStr = newValue.text;
    int startIndex = newValue.selection.baseOffset;
    int endIndex = newValue.selection.extentOffset;

    var otherLength =
    // (newStr.split(' ').length - 1) +
    (newStr.split('.').length - 1) +
        (newStr.split(',').length - 1) +
        (newStr.split('/').length - 1) +
        (newStr.split('N').length - 1) +
        (newStr.split(';').length - 1) +
        (newStr.split('*').length - 1) +
        (newStr.split('-').length - 1) +
        (newStr.split('#').length - 1);
    if (otherLength > 0) {
      // newStr = newStr.replaceAll(' ', '');
      newStr = newStr.replaceAll('.', '');
      newStr = newStr.replaceAll(',', '');
      newStr = newStr.replaceAll('/', '');
      newStr = newStr.replaceAll('N', '');
      newStr = newStr.replaceAll(';', '');
      newStr = newStr.replaceAll('*', '');
      newStr = newStr.replaceAll('-', '');
      newStr = newStr.replaceAll('#', '');
      startIndex -= otherLength;
      endIndex -= otherLength;
    }

    ///Character '+' insertion
    if (!newStr.startsWith('+')) {
      newStr = '+$newStr';
      startIndex++;
      endIndex++;
    }
    otherLength = newStr.split('+').length - 1;
    if (otherLength > 1) {
      newStr = '+${newStr.substring(1).replaceAll('+', '')}';
      startIndex -= (otherLength - 1);
      endIndex -= (otherLength - 1);
    }

    if (newStr.length >= 2 && newStr[1] != '7') {
      // newStr = newStr.replaceAll(')', '');
      if (newStr.length >= 2) {
        newStr = newStr.replaceRange(1, 1, '7');
      }

      startIndex = startIndex + 1;
      endIndex = endIndex + 1;
    }
    // if (newStr.length >= 8) {
    //   newStr = newStr.replaceAll(' ', '');
    //   var addition = 0;
    //   if (newStr.length >= 8) {
    //     newStr = newStr.replaceRange(7, 7, ' ');
    //     addition++;
    //   }
    //   if (newStr.length >= 12) {
    //     newStr = newStr.replaceRange(11, 11, ' ');
    //     addition++;
    //   }
    //   if (newStr.length >= 15) {
    //     newStr = newStr.replaceRange(14, 14, ' ');
    //     addition++;
    //   }
    //
    //   startIndex = startIndex - spacesLength + addition;
    //   endIndex = endIndex - spacesLength + addition;
    // }
    //

    var fBracketLength = newStr.split('(').length - 1;
    var sBracketLength = newStr.split(')').length - 1;
    var spacesLength = newStr.split(' ').length - 1;

    ///Bracket '(' insertion
    if ((newStr.length >= 3 && newStr[2] != '(') || fBracketLength > 1) {
      newStr = newStr.replaceAll('(', '');
      if (newStr.length >= 3) {
        newStr = newStr.replaceRange(2, 2, '(');
      }

      startIndex = startIndex - fBracketLength + 1;
      endIndex = endIndex - fBracketLength + 1;
    }
    ///Bracket ')' insertion
    if ((newStr.length >= 7 && newStr[6] != ')') || sBracketLength > 1) {
      newStr = newStr.replaceAll(')', '');
      if (newStr.length >= 7) {
        newStr = newStr.replaceRange(6, 6, ')');
      }

      startIndex = startIndex - sBracketLength + 1;
      endIndex = endIndex - sBracketLength + 1;
    }

    ///Spacers insertion
    if (newStr.length >= 8) {
      newStr = newStr.replaceAll(' ', '');
      var addition = 0;
      if (newStr.length >= 8) {
        newStr = newStr.replaceRange(7, 7, ' ');
        addition++;
      }
      if (newStr.length >= 12) {
        newStr = newStr.replaceRange(11, 11, ' ');
        addition++;
      }
      if (newStr.length >= 15) {
        newStr = newStr.replaceRange(14, 14, ' ');
        addition++;
      }

      startIndex = startIndex - spacesLength + addition;
      endIndex = endIndex - spacesLength + addition;
    }

    ///+7(800) 555 35 35 - 17 length, that line clamp length of string
    if (newStr.length > 17) {
      newStr = newStr.substring(0, 17);
      startIndex = startIndex > 17 ? 17 : startIndex;
      endIndex = endIndex > 17 ? 17 : endIndex;
    }

    return TextEditingValue(
      text: newStr,
      selection: newValue.selection.copyWith(
        baseOffset: startIndex,
        extentOffset: endIndex,
      ),
    );
  }
}