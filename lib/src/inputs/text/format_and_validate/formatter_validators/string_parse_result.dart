abstract class ValueAndError<C> {
  final C? formattedContent;
  final bool? isStringValid;
  final String? errorMessage;

  const ValueAndError._(this.formattedContent, [this.isStringValid, this.errorMessage]);

  const ValueAndError.transient(C formattedContent) : this._(formattedContent);

  const ValueAndError.ok(C? formattedContent) : this._(formattedContent, true);

  const ValueAndError.err(C? formattedContent, String? errorMessage) : this._(formattedContent, false, errorMessage);
}

abstract class ValueDisplayError<C, V> extends ValueAndError<C> {
  final V? parsedValue;

  const ValueDisplayError.transient(C formattedContent)
      : parsedValue = null,
        super.transient(formattedContent);

  const ValueDisplayError.ok(C? formattedContent, this.parsedValue) : super.ok(formattedContent);

  const ValueDisplayError.err(C? formattedContent, String? errorMessage)
      : parsedValue = null,
        super.err(formattedContent, errorMessage);
}

final class DateTimeValueAndError extends ValueDisplayError<String, DateTime> {
  const DateTimeValueAndError.transient(String formattedContent) : super.transient(formattedContent);

  const DateTimeValueAndError.ok(String? formattedContent, DateTime? parsedValue)
      : super.ok(formattedContent, parsedValue);

  const DateTimeValueAndError.err(String? formattedContent, String? errorMessage)
      : super.err(formattedContent, errorMessage);
}
