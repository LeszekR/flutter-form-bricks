class DateTimeTestCase {
  final String input;
  final String expectedValueText;
  final bool expectedIsValid;
  final String? expectedError;

  DateTimeTestCase(this.input, this.expectedValueText, this.expectedIsValid, this.expectedError);
}
