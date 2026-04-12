enum ErrorLocation { withTextField, formErrorArea, both }

enum ErrorBehaviour { dynamicSpaceBelowField, fixedSpaceBelowField, never }

class ErrorConfig {
  final ErrorLocation errorLocation;
  final ErrorBehaviour errorBehaviour;

  const ErrorConfig({
    this.errorLocation = ErrorLocation.withTextField,
    this.errorBehaviour = ErrorBehaviour.dynamicSpaceBelowField,
  });
}
