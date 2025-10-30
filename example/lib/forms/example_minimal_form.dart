import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class ExampleMinimalForm extends SingleForm {
  ExampleMinimalForm({super.key});

  @override
  _ExampleMinimalFormState createState() => _ExampleMinimalFormState();
}

class _ExampleMinimalFormState extends SingleFormState {
  @override
  List<Widget> createBody(BuildContext context) {
    return [
      FormUtils.horizontalFormGroup(context: context, children: [
        DateTimeInputs.dateTimeRange(
          context: context,
          rangeId: "rng",
          formManager: formManager,
          currentDate: CurrentDate(),
          dateTimeLimits: DateTimeLimits(),
          maxRangeSpanDays: 8,
          minRangeSpanMinutes: 15,
          labelPosition: LabelPosition.topLeft,
          label: "Załadunek",
          initialRangeStartDate: Date.fromString('2024-12-15'),
        ),
      ])
    ];
  }

  @override
  String provideLabel() => "Minimal Form";

  @override
  void deleteEntity() {
    // TODO: implement deleteEntity
  }

  @override
  void submitData() {
    // TODO: implement submitData
  }
}
