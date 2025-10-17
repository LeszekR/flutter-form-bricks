class CurrentDate {
  static CurrentDate? _instance;

  CurrentDate._();

  factory CurrentDate() {
    _instance ??= CurrentDate._();
    return _instance!;
  }

  DateTime getCurrentDate() {
    return DateTime.now();
  }
}
