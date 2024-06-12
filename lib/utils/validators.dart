part of '../kit4.dart';

enum ValidatorType {
  url,
  email,
  emailOrPhone,
  phone,
  empty,
  integer,
  code,
  name,
  password,
}

class Validators {
  static String? emailValidation(String? email) {
    if (email == null || email.replaceAll(' ', '') == '') {
      return 'Поле не может быть пустым';
    }

    //Тоже валидирует во многих случаях, но не во всех вроде
    // static const String emailRegex =
    //     r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)";

    RegExp regExp = RegExp(
        r"[-0-9!#$%&'*+/=?^_`{|}~A-Za-z]+(?:\.[-0-9!#$%&'*+/=?^_`{|}~A-Za-z]+)*@(?:[0-9A-Za-z](?:[-0-9A-Za-z]*[0-9A-Za-z])?\.)+[0-9A-Za-z](?:[-0-9A-Za-z]*[0-9A-Za-z])?",
        caseSensitive: false,
        multiLine: false);
    if (!regExp.hasMatch(email)) {
      return 'Недопустимый формат Email';
    }

    return null;
  }

  static String? emailOrPhoneValidation(String? text, {String? startWith}) {
    if (emptyValidation(text) != null) return 'Поле не может быть пустым';
    if (emailValidation(text) == null) return null;
    if (phoneValidation(text) == null) return null;
    return 'Укажите корректный номер телефона или Email';
  }

  static String? phoneValidation(String? text, {String? startWith}) {
    if (text == null || text.replaceAll(' ', '') == '') {
      return 'Поле не может быть пустым';
    }

    if (startWith != null && !text.startsWith(startWith)) {
      return 'Должно начинаться на $startWith';
    }

    text = text.replaceAll(' ', '');
    text = text.replaceAll('(', '');
    text = text.replaceAll(')', '');
    try {
      final phone = PhoneNumber.parse(text);

      if (!phone.isValid(type: PhoneNumberType.mobile)) {
        return 'Укажите корректный номер телефона';
      }
    } catch (e) {
      return 'Укажите корректный номер телефона';
    }

    return null;
  }

  static String? urlValidation(String? text) {
    if (text?.replaceAll(' ', '').isEmpty ?? true) {
      return 'Поле не может быть пустым';
    }

    var uri = Uri.tryParse(text!);
    "uri.isAbsolute = ${uri?.isAbsolute}".log();
    if (uri?.isAbsolute ?? false) return null;
    return "Текст не является ссылкой";
  }

  static String? emptyValidation(String? text, [int? maxLength]) {
    if (text == null || text.replaceAll(' ', '') == '') {
      return 'Поле не может быть пустым';
    }
    if (maxLength != null && text.length > maxLength) {
      return 'Поле больше $maxLength длины';
    }
    return null;
  }

  static String? intValidation(String? text) {
    if (text == null || text.replaceAll(' ', '') == '') {
      return 'Поле не может быть пустым';
    }
    if (int.tryParse(text) == null) {
      return 'Должно быть указано число';
    }
    return null;
  }

  static String? codeValidation(String? code, int minLength) {
    if (code == null || code.replaceAll(' ', '') == '') {
      return 'Поле не может быть пустым';
    }

    if (code.length < minLength) {
      return 'Код должен содержать $minLength или более символов';
    }

    RegExp regExp = RegExp(r"[0-9]", caseSensitive: false, multiLine: false);
    if (!regExp.hasMatch(code)) {
      return 'Недопустимый формат для кода';
    }
    return null;
  }

  static String? nameValidation(String? name, int minLength) {
    if (name == null || name.replaceAll(' ', '') == '') {
      return 'Поле не может быть пустым';
    }

    if (name.length < minLength) {
      // return 'Ваше имя должно содержать $minLength или более символов';
      return 'Ваше имя должно содержать $minLength и не более 32 символов';
    }
    if (name.length >= 32) {
      return 'Ваше имя должно содержать $minLength и не более 32 символов';
    }

    RegExp regExp =
        RegExp(r"^[\w\W]{1,32}$", caseSensitive: false, multiLine: false);
    if (!regExp.hasMatch(name)) {
      return 'Недопустимый формат';
    }

    return null;
  }

  static PasswordValidationResult passwordValidation(
    String? password, {
    int? minLength,
    int? maxLength,
    // String? startWith,
  }) {
    if (password == null || password.replaceAll(' ', '') == '') {
      return PasswordValidationResult(true, false, false, false);
    }

    var numberSymbols = minLength == null ? true : password.length >= minLength;
    numberSymbols &= maxLength == null ? true : password.length <= maxLength;

    RegExp regExp = RegExp(
        r"^(?=\D*\d)(?=.*[A-Z])(?=.*[a-z])[ A-Za-z0-9!%&?]*$"); //, caseSensitive: true, multiLine: false);
    var capitalLettersNumbers = regExp.hasMatch(password);

    var specialSymbols = password.contains("%") ||
        password.contains("&") ||
        password.contains(".") ||
        password.contains(",") ||
        password.contains("#") ||
        password.contains("*") ||
        password.contains("!") ||
        password.contains("?");

    return PasswordValidationResult(
        false, numberSymbols, capitalLettersNumbers, specialSymbols);
  }
}

class PasswordValidationResult {
  PasswordValidationResult(
    this.empty,
    this.numberSymbols,
    this.capitalLettersNumbers,
    this.specialSymbols,
  );

  final bool empty;
  final bool numberSymbols;
  final bool capitalLettersNumbers;
  final bool specialSymbols;

  bool get passwordValidated =>
      specialSymbols && numberSymbols && capitalLettersNumbers;

  String? get errorMessage {
    if (empty) return 'Поле не может быть пустым';
    if (passwordValidated) return null;
    return "Все условия должны быть соблюдены";
  }
}
