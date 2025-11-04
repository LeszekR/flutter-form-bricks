import '../../inputs/state/form_field_data.dart';

abstract class FormData {
  final Map<String, FormFieldData> fieldDataMap = {};
  String? focusedKeyString;

  FormData({required this.focusedKeyString});
}
