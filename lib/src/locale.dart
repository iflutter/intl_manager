class Locale {
  String languageCode;
  String countryCode;

  Locale(this.languageCode, [this.countryCode]);

  factory Locale.parse(String localeStr) {
    List<String> parts = localeStr.split("-");
    if (parts.length < 1) {
      parts = localeStr.split("_");
    }
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }

  @override
  String toString() {
    if (countryCode == null) {
      return 'Locale $languageCode';
    } else {
      return 'Locale $languageCode-$countryCode';
    }
  }

  String toLocaleString(String linkChar) {
    if (countryCode == null) {
      return '$languageCode';
    } else {
      return '$languageCode$linkChar$countryCode';
    }
  }

  String joinToFileName(String name, String linkChar) {
    if (countryCode == null) {
      return '$name$linkChar$languageCode';
    } else {
      return '$name$linkChar$languageCode$linkChar$countryCode';
    }
  }

  bool isSameLocale(Locale locale) {
    return locale.languageCode == languageCode &&
        locale.countryCode == countryCode;
  }

  bool isEmpty() {
    return languageCode == null || languageCode.length < 1;
  }
}
