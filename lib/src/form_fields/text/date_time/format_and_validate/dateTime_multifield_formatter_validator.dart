import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/form_fields/components/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_utils.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

abstract class DateTimeMultiFieldFormatterValidator extends FormatterValidator<TextEditingValue, DateTime> {
  FormManager? _formManager;
  final DateTimeUtils dateTimeUtils;
  final CurrentDate currentDate;

  List<String> keyStrings = [];
  final Map<String, DateTimeFieldContent> resultsCache = {};
  final Map<String, FormatterValidator> formatterValidators = {};

  void set formManager(FormManager formManager) {
    if (_formManager == null) _formManager = formManager;
  }

  FormManager get formManager => _formManager!;

  void setComponentFieldsKeyStrings(String keyString);

  void fillDateTimeFormatterValidatorsMap();

  void validateFieldsGroup(BricksLocalizations localizations);

  DateTimeMultiFieldFormatterValidator(
    String keyString,
    this.dateTimeUtils,
    this.currentDate,
  ) : assert(
            !keyString.contains('~'),
            'DateTimeMultiFieldFormatterValidator keyString must not contain "~"'
            ' - it is reserved for use in automatically added postfixes.') {
    setComponentFieldsKeyStrings(keyString);
    fillDateTimeFormatterValidatorsMap();
  }

  @override
  DateTimeFieldContent run(
    BricksLocalizations localizations,
    String keyString,
    TextEditingValue? input,
  ) {
    //
    _validateField(localizations, keyString, input);

    _validateOtherFields(localizations, keyString);

    // All four fields will be validated against range criteria  by now - checked for date/times correctness.
    // FieldContent of the field which triggered validation here will be stored after being returned from this method.
    // The other fields' contents will be stored in FormManager -> FormData here.
    if (_areAllFieldsValid()) {
      validateFieldsGroup(localizations);
    }

    // FieldContent returned here will:
    // - be stored in FormData by FormManager
    // - FieldContent.input (just formatted by FormatterValidator) will be entered into the field
    return _getFieldContent(keyString)!;
  }

  void _validateField(
    BricksLocalizations localizations,
    String keyString,
    TextEditingValue? input,
  ) {
    FormatterValidator fieldFormaterValidator = formatterValidators[keyString]!;
    DateTimeFieldContent validatedContent =
        fieldFormaterValidator.run(localizations, keyString, input) as DateTimeFieldContent;

    // FieldContent cached here will be used during validation of any DateTime fields contained in
    // this formatter-validator by:
    // - providing FieldContent.isValid for future validation of other fields in this DateTimeRangeField
    // - providing FieldContent to be stored in FormManager, (including the field's input and value)
    _cacheFieldContent(keyString, validatedContent);
  }

  void _validateOtherFields(
    BricksLocalizations localizations,
    String excludedKeyString,
  ) {
    TextEditingValue? input;
    for (String keyString in _getOtherFieldsKeyStrings(excludedKeyString)) {
      if (_getFieldContent(keyString)?.isValid == null) {
        input = (formManager.getFieldContent(keyString) as DateTimeFieldContent).input;
        _validateField(localizations, keyString, input);
      }
    }
  }

  bool _areAllFieldsValid() {
    for (String keyString in keyStrings) {
      if (!formManager.getFieldContent(keyString).isValid!) return false;
    }
    return true;
  }

  Iterable<String> _getOtherFieldsKeyStrings(String? excludedKeyString) {
    var otherFields = keyStrings.where((k) => k != excludedKeyString);
    return otherFields;
  }

  DateTimeFieldContent? _getFieldContent(String keyString) {
    return formManager.getFieldContent(keyString) as DateTimeFieldContent;
  }

  void _cacheFieldContent(String keyString, DateTimeFieldContent fieldContent) {
    formManager.storeFieldContent(keyString, fieldContent);
  }

  void cacheError(String keyString, String errorText) {
    _cacheFieldContent(keyString, _getFieldContent(keyString)!.copyWith(error: errorText));
  }
}
