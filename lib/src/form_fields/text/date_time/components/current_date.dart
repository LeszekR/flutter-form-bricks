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

class A {
  final int? x;
  const A(this.x);
}

class B extends A {
  B(super.x);
}

class C extends B {
  C(super.x);
}
