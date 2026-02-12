String groupKeyFromText(String? value) {
  if (value == null || value.trim().isEmpty) {
    return '#';
  }
  final first = value.trim().substring(0, 1).toUpperCase();
  final isAlpha = RegExp(r'[A-Z]').hasMatch(first);
  final isDigit = RegExp(r'[0-9]').hasMatch(first);
  if (isAlpha || isDigit) {
    return first;
  }
  return '#';
}
