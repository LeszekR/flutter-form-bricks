class CurrentDate {
  static CurrentDate? _instance;

  CurrentDate._();

  factory CurrentDate() {
    return _instance ??= CurrentDate._();
  }

  DateTime now() {
    return DateTime.now();
  }
}
