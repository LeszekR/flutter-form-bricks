import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class ExampleMinimalForm extends SingleForm {
  ExampleMinimalForm({super.key});

  @override
  SingleFormStateData<SingleForm> createState() => _ExampleMinimalFormState();
}

class _ExampleMinimalFormState extends SingleFormStateData<ExampleMinimalForm> {
  @override
  List<Widget> createBody(BuildContext context) {
    return [
      FormUtils.horizontalFormGroup(context: context,children: [
        DateTimeInputs.dateTimeRange(
          context: context,
          rangeId: "rng",
          formManager: formManager,
          labelPosition: LabelPosition.topLeft,
          label: "Załadunek",
          initialRangeStartDate: Date.fromString('2024-12-15'),
        ),
      ])
    ];
  }

  @override
  String provideLabel() => "Minimal Form";

  // @override
  // Entity? getEntity() => null;
  //
  // @override
  // EntityService<Entity> getService() => throw UnimplementedError();

  @override
  void removeEntityFromState() {}

  @override
  void upsertEntityInState(Map<String, dynamic> responseBody) {}
}
