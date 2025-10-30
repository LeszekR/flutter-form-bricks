class StringParseResult<T> {
  final String parsedString;
  final T? parsedValue;
  final bool isStringValid;
  final String? errorMessage;

  StringParseResult(this.parsedString, this.parsedValue, this.isStringValid, [this.errorMessage]);

  factory StringParseResult.ok(String parsed, T value) => StringParseResult(parsed, value, true);

  factory StringParseResult.transient(String parsed) => StringParseResult(parsed, null, true);

  factory StringParseResult.err(String parsed, T? value, String? message) =>
      StringParseResult(parsed, value, false, message);
}
