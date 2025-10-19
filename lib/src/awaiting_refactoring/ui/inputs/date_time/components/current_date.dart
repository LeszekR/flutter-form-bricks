class CurrentDate {
  static CurrentDate? _instance;

  CurrentDate._();

  factory CurrentDate() {
    return _instance ??= CurrentDate._();
  }

  DateTime getDateNow() {
    return DateTime.now();
  }
}
