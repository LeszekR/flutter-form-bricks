import 'package:flutter_form_bricks/src/form_fields/base/form_field_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/base/formatter_validator_base/formatter_validator_chain.dart';
import 'package:flutter_form_bricks/src/form_fields/text/text_input_base/formatter_validator_defaults.dart';

class FormFieldDescriptor<I extends Object, V extends Object> {
  final String keyString;
  final Type inputRuntimeType = I;
  final Type valueRuntimeType = V;
  final bool isRequired;
  final bool runValidatorsFullRun;
  final bool runDefaultValidatorsFirst;
  final I? initialInput;
  final bool? isFocusedOnStart;
  final FormatterValidatorListMaker<I, V>? defaultFormatterValidatorListMaker;
  final FormatterValidatorListMaker<I, V>? addFormatterValidatorListMaker;

  // TODO guarantee validator chain adequate to field type - e.g. checkbox with date-validator throws

  FormFieldDescriptor({
    required this.keyString,
    this.initialInput,
    this.isFocusedOnStart,
    this.isRequired = FormFieldBrick.defaultIsRequired,
    this.runValidatorsFullRun = FormFieldBrick.defaultValidatorsFullRun,
    this.runDefaultValidatorsFirst = FormFieldBrick.defaultRunDefaultValidatorsFirst,
    this.defaultFormatterValidatorListMaker,
    this.addFormatterValidatorListMaker,
  })  : assert(I != dynamic, "FormFieldDescriptor<I, V>: Generic type I must not be dynamic."),
        assert(V != dynamic, "FormFieldDescriptor<I, V>: Generic type V must not be dynamic.");

  FormatterValidatorChain<I, V>? buildChain() => _buildFormatterValidatorChainForDescriptor<I, V>(this);
}

/// Builds a [`FormatterValidatorChain`] for a descriptor by combining its default and additional validators.
///
/// Chain policy:
/// - When [runValidatorsFullRun] is `true` (default), returns a [FormatterValidatorChainFullRun]:
///   runs **all** validators in order and returns the final `FieldContent`.
/// - When [runValidatorsFullRun] is `false`, returns a [FormatterValidatorChainEarlyStop]:
///   runs validators until the running result becomes **invalid**, then stops early,
///   or runs to the end if no invalid result is encountered.
///
/// Combination rules:
/// - If both defaults and additions exist:
///   - When [runDefaultValidatorsFirst] is `true` (default): **defaults → additions**
///   - When [runDefaultValidatorsFirst] is `false`: **additions → defaults**
/// - If only one list exists, that list is used as-is.
/// - If neither exists, returns `null`.
///
/// This helper centralizes how descriptor-provided defaults and app-provided additions
/// are merged and which chain execution policy is used.
///
/// See also: [FormatterValidatorChain], [FormatterValidatorChainFullRun], [FormatterValidatorChainEarlyStop].
FormatterValidatorChain<I, V>? _buildFormatterValidatorChainForDescriptor<I extends Object, V extends Object>(
    FormFieldDescriptor<I, V> d) {
  List<FormatterValidator<I, V>>? formatterValidatorList = null;
  final List<FormatterValidator<I, V>>? defaults = d.defaultFormatterValidatorListMaker?.call();
  final List<FormatterValidator<I, V>>? additions = d.addFormatterValidatorListMaker?.call();

  if (defaults != null && additions != null) {
    if (d.runDefaultValidatorsFirst) {
      defaults.addAll(additions);
      formatterValidatorList = defaults;
    } else {
      additions.addAll(defaults);
      formatterValidatorList = additions;
    }
  }
  if (additions != null) {
    formatterValidatorList = additions;
  }
  if (defaults != null) {
    formatterValidatorList = defaults;
  }

  if (formatterValidatorList == null) {
    return null;
  } else if (d.runValidatorsFullRun) {
    return FormatterValidatorChainFullRun<I, V>(formatterValidatorList);
  } else {
    return FormatterValidatorChainEarlyStop<I, V>(formatterValidatorList);
  }
}
