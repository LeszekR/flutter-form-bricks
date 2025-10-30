class TextInputValue<T> {
  final String? inputString;
  final T? parsedValue;

  const TextInputValue({this.inputString, this.parsedValue});
}