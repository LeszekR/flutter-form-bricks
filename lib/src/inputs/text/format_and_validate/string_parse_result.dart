class StringParseResult {
  final String parsedString;
  final bool isStringValid;
  final String? errorMessage;

  StringParseResult(this.parsedString, this.isStringValid, [this.errorMessage]);

  factory StringParseResult.ok(String parsed) => StringParseResult(parsed, true);

  factory StringParseResult.err(String parsed, String message) => StringParseResult(parsed, false, message);
}
