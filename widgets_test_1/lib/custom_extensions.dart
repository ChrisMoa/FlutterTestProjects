// An extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  bool toBool() {
    return (int.tryParse(this) ?? 0) == 0 ? true : false;
  }

  double toDouble() {
    return double.tryParse(this) ?? 0.0;
  }

  int toInt() {
    return int.tryParse(this) ?? 0;
  }
}
