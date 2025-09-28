extension StringCasingExtension on String {
  String get toCapitalized => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized).join(' ');
}

extension NumUnitConversion on num {
  double get toMetersFromDm => this / 10.0;
  double get toKgFromHg => this / 10.0;
}
