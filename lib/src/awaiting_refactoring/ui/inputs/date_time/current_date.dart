class CurrentDate {
  static CurrentDate? _instance;

  CurrentDate._();

  factory CurrentDate() {
    _instance ??= CurrentDate._();
    return _instance!;
  }

  DateTime getDateNow() {
    return DateTime.now();
  }
}
