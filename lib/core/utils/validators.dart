class Validators {
  static bool isEmail(String value) {
    return value.contains('@') && value.contains('.');
  }

  static bool isPassword(String value) => value.length >= 6;

  static String? loginError(String email, String password) {
    if (email.trim().isEmpty) return 'email_required';
    if (password.isEmpty) return 'password_required';
    if (!isEmail(email) || !isPassword(password)) {
      return 'Invalid email or password';
    }
    return null;
  }

  static String? registerError({
    required String fullName,
    required String email,
    required String phone,
    required String idNumber,
    required String password,
  }) {
    if (fullName.trim().isEmpty) return 'Full name cannot be empty.';
    if (!isEmail(email)) return 'Please enter a valid email address.';
    if (phone.length < 10 || !RegExp(r'^\d+$').hasMatch(phone)) {
      return 'Phone number must be at least 10 digits and contain only numbers.';
    }
    if (idNumber.trim().isEmpty) return 'ID number cannot be empty.';
    if (!isPassword(password)) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }
}
