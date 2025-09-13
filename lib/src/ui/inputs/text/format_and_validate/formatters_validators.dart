// TODO - check, test, correct, refactor
// TODO - refactor all formatters and validators to this pattern

// The goal:
// - Keep your `StringParseResult` concept.
// - Clearly separate --formatters-- (normalize text, add zeros, add year) from --validators--
//    (check ranges, leap year, too many digits, etc.).
// - Enable chaining so new rules can be added without bloating methods.
//
// Benefits
// - Clear separation: formatters modify, validators check.
// - No duplication: leap year logic only in `DateExistenceValidator`.
// - Extensible: just add another step to the pipeline.
// - Familiar: mirrors how Angular, React Hook Form, and FormBuilder do it.

// Common interface

import 'formatter_validator.dart';
import 'formatter_validator_chain.dart';
import 'string_parse_result.dart';


//  Build formatters
// These only **transform** strings, never fail.

class TrimFormatter implements FormatterValidator {
  @override
  StringParseResult call(StringParseResult input) {
    final trimmed = input.parsedString.trim().replaceAll(RegExp(' +'), ' ');
    return StringParseResult.ok(trimmed);
  }
}

abstract class DateFormatterValidator extends FormatterValidator {}

class DateAddLeadingZerosFormatter implements DateFormatterValidator {
  @override
  StringParseResult call(StringParseResult input) {
    final parts = input.parsedString.split('-');
    if (parts.length >= 2) {
      final day = parts.last.padLeft(2, '0');
      final month = parts[parts.length - 2].padLeft(2, '0');
      final year = parts.length == 3 ? parts.first : '';
      final newDate = [year, month, day].where((e) => e.isNotEmpty).join('-');
      return StringParseResult.ok(newDate);
    }
    return input;
  }
}

class DateAddYearFormatter implements DateFormatterValidator {
  final int currentYear;

  DateAddYearFormatter(this.currentYear);

  @override
  StringParseResult call(StringParseResult input) {
    final parts = input.parsedString.split('-');
    if (parts.length == 2) {
      final year = currentYear.toString();
      return StringParseResult.ok('$year-${parts[0]}-${parts[1]}');
    }
    return input;
  }
}

// Validators
//
// These only **check** values, may set error.

class DateYearRangeValidator implements DateFormatterValidator {
  final int minYear;
  final int maxYear;

  DateYearRangeValidator(this.minYear, this.maxYear);

  @override
  StringParseResult call(StringParseResult input) {
    final parts = input.parsedString.split('-');
    if (parts.length == 3) {
      final year = int.tryParse(parts[0]);
      if (year == null || year < minYear || year > maxYear) {
        return StringParseResult.err(input.parsedString, 'Year must be between $minYear and $maxYear');
      }
    }
    return input;
  }
}

class DateExistenceValidator implements FormatterValidator {
  @override
  StringParseResult call(StringParseResult input) {
    try {
      final parts = input.parsedString.split('-');
      if (parts.length != 3) {
        return StringParseResult.err(input.parsedString, 'Invalid date format');
      }
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      final date = DateTime(year, month, day); // throws if invalid
      if (date.month != month || date.day != day) {
        return StringParseResult.err(input.parsedString, 'Invalid date');
      }
      return input;
    } catch (_) {
      return StringParseResult.err(input.parsedString, 'Invalid date');
    }
  }
}

//  Chain executor


// TODO decide on early stop or full run

// Usage
final datePipeline = FormatterValidatorChainFullRun([
  TrimFormatter(),
  DateAddLeadingZerosFormatter(),
  DateAddYearFormatter(DateTime.now().year),
  DateYearRangeValidator(1900, 2100),
  DateExistenceValidator(),
]);

final result = datePipeline.run("  2-3 ");
// => parsed: "2025-03-02", isValid: true
