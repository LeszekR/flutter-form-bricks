part of 'example_form.dart';

class ExampleFormSchema extends FormSchema {
  ExampleFormSchema()
      : super(
            formKey: GlobalKey<FormStateBrick>(),
            initiallyFocusedKeyString: plainTextKeyString2,
            // initiallyFocusedKeyString: lowerCaseKeyString3,
            fieldDescriptors: <FormFieldDescriptor>[
              DateFieldDescriptor(
                keyString: dateKeyString1,
                initialInput: TextEditingValue(),
              ),
              TimeFieldDescriptor(
                keyString: timeKeyString1,
                initialInput: TextEditingValue(text: '00'),
              ),
              PlainTextFieldDescriptor(
                keyString: plainTextKeyString2,
                initialInput: TextEditingValue(text: 'Zenon'),
              ),
              LowerCaseFieldDescriptor(
                keyString: lowerCaseKeyString3,
              ),
              DateTimeSeparatedFieldDescriptor(
                keyString: dateTimeSeparatedKeString1,
                initialInputSet: DateTimeSeparatedInitialSet(
                  date: "zenon",
                  time: "stefa",
                ),
              ),
            ]);
}
