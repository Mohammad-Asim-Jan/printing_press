String? isNotEmpty(String? value) {
  if (value == null || value.isEmpty) return 'This field cannot be empty';
  return null;
}

String? isEmailValid(String? value) {
  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regex = RegExp(pattern);
  if (value == null || !regex.hasMatch(value)) return 'Enter a valid email';
  return null;
}

String? hasMinLength(String? value, {int minLength = 6}) {
  if (value == null || value.length < minLength) {
    return 'Minimum length is $minLength';
  }
  return null;
}

String? isNotZero(String? value) {
  if (int.tryParse(value!) == 0) return 'This field cannot be zero';
  return null;
}

String? lessThan(String? value, int max) {
  if (int.tryParse(value!)! > max) {
    return 'Maximum value is $max';
  }
  return null;
}


String? moreThan(String? value, int min) {
  if (int.tryParse(value!)! < min) {
    return 'Minimum value is $min';
  }
  return null;
}
// (value) => hasMinLength(value, minLength: 8),
