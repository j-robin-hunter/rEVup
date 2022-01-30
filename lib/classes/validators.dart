//************************************************************
//
//
// Copyright 2022 Roma Technology Limited, All rights reserved
//
//************************************************************

class Validators {
  static String? validateEmail(String? value) {
    String pattern =
    r"""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Please provide a valid email address';
    } else {
      return null;
    }
  }

  static String? validateNotEmpty(value) {
    if (value == null || value.isEmpty) {
      return 'This is a required field, please provide a value';
    }
    return null;
  }

  static String? validatePostcode(String? value) {
    String pattern = r"^([A-Z][A-HJ-Y]?[0-9][A-Z0-9]? ?[0-9][A-Z]{2}|GIR ?0A{2})$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Please provide a valid postcode';
    } else {
      return null;
    }
  }

  static String? validatePostcodeNotRequired(String? value) {
    String pattern = r"^$|^([A-Z][A-HJ-Y]?[0-9][A-Z0-9]? ?[0-9][A-Z]{2}|GIR ?0A{2})$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Please provide a valid postcode';
    } else {
      return null;
    }
  }

  static String? validatePhone(String? value) {
    String pattern = r"(((\+44)? ?(\(0\))? ?)|(0))( ?[0-9]{3,4}){3}";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Please provide a valid phone number';
    } else {
      return null;
    }
  }

  static String? validatePhoneNotRequired(String? value) {
    String pattern = r"^$|(((\+44)? ?(\(0\))? ?)|(0))( ?[0-9]{3,4}){3}";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Please provide a valid phone number';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? value) {
    RegExp lowerCase = RegExp(r"^(?=.*[a-z])");
    RegExp upperCase = RegExp(r"^(?=.*[A-Z])");
    RegExp number = RegExp(r"(?=.*\d)");
    RegExp special = RegExp(r"(?=.*[@$!%*?&_~#])");
    if (value == null || value.isEmpty || value.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (!lowerCase.hasMatch(value)) {
      return 'No lower case letters';
    } else if (!upperCase.hasMatch(value)) {
      return 'No upper case letters';
    } else if (!number.hasMatch(value)) {
      return 'No numbers';
    } else if (!special.hasMatch(value)) {
      return 'No special characters: @\$!%*?&_~#';
    } else {
      return null;
    }
  }
}