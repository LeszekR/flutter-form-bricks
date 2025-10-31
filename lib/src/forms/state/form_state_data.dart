import '../../inputs/state/form_field_state_data.dart';

abstract class FormStateData {
  final Map<String, FormFieldStateData> fieldStateDataMap = {};
  String? focusedKeyString;
  bool get isInitialised => fieldStateDataMap.isNotEmpty;
}
