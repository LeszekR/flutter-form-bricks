enum ErrorPosition { withTextField, formErrorArea, both }

enum ErrorBehaviour { dynamicSpaceBelowField, fixedSpaceBelowField, never }

class ErrorConfig {
  final ErrorPosition position;
  final ErrorBehaviour behaviour;

  const ErrorConfig({
    this.position = ErrorPosition.withTextField,
    this.behaviour = ErrorBehaviour.dynamicSpaceBelowField,
  });
}
