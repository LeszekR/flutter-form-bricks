part of 'example_form.dart';

class ExampleFormSchema extends FormSchema {
  ExampleFormSchema()
      : super(
          formKey: GlobalKey<FormStateBrick>(),
          initiallyFocusedKeyString: plainTextKeyString1,
        );

  @override
  List<FormFieldDescriptor<Object, Object, Widget>> get fieldDescriptorsList => <FormFieldDescriptor>[
        PlainTextFieldDescriptor(
          keyString: plainTextKeyString2,
        ),
        DateFieldDescriptor(
          keyString: dateKeyString1,
          initialInput: TextEditingValue(),
        ),
        DateFieldDescriptor(
          keyString: dateKeyString2,
          initialInput: TextEditingValue(text: 'yyy'),
        ),
        DateFieldDescriptor(
          keyString: dateKeyString3,
          initialInput: TextEditingValue(text: '8/31'),
        ),
        DateFieldDescriptor(
          keyString: dateKeyString5,
          initialInput: TextEditingValue(text: '8/31'),
        ),
        DateFieldDescriptor(
          keyString: dateKeyString4,
          initialInput: TextEditingValue(text: '5/15 stefan'),
        ),
        TimeFieldDescriptor(
          keyString: timeKeyString1,
          initialInput: TextEditingValue(text: '00'),
        ),
        PlainTextFieldDescriptor(
          keyString: plainTextKeyString1,
          initialInput: TextEditingValue(text: 'Marian'),
        ),
        LowerCaseFieldDescriptor(
          keyString: lowerCaseKeyString3,
        ),
        DateTimeSeparatedFieldDescriptor(
          keyString: dateTimeSeparatedKeyString1,
          initialInputSet: DateTimeSeparatedInitialSet(
            date: "zenon",
            time: "stefa",
          ),
        ),
      ];
}
