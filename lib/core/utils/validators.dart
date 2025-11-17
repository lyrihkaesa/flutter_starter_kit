import '../constants/app_constants.dart';

class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    if (!AppRegex.email.hasMatch(value)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!AppRegex.password.hasMatch(value)) {
      return 'Password must contain letters and numbers';
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // TRON address validation
  static String? tronAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'TRON address is required';
    }

    if (!AppRegex.tronAddress.hasMatch(value)) {
      return 'Please enter a valid TRON address';
    }

    return null;
  }

  // Amount validation
  static String? amount(String? value, {double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (min != null && amount < min) {
      return 'Minimum amount is $min';
    }

    if (max != null && amount > max) {
      return 'Maximum amount is $max';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    return null;
  }

  // Phone number validation (optional)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    if (value.length < 10) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Referral code validation
  static String? referralCode(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    if (value.length < 6) {
      return 'Invalid referral code';
    }

    return null;
  }
}
