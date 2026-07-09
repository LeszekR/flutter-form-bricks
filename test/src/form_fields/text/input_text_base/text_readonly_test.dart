

void main() {
  const userText = 'New input';

  // TODO - implement readonly functionality in FormFieldBrick and test on all types of fields - text, choice, etc
  // testWidgets('Readonly input should not accept input', (WidgetTester tester) async {
  //   //given
  //   await prepareWidget(
  //     tester,
  //     (context) => BasicTextInput.basicTextInput(
  //       context: context,
  //       keyString: 'testInput',
  //       label: 'Test Input',
  //       autovalidateMode: AutovalidateMode.onUserInteraction,
  //       labelPosition: LabelPosition.topLeft,
  //       formManager: TestFormManager.testDefault(),
  //       readonly: true,
  //     ),
  //   );
  //   final inputField = find.byType(FormBuilderTextField);
  //
  //   //when
  //   await tester.enterText(inputField, userText);
  //   await tester.pump();
  //
  //   //then
  //   expect(find.text(userText), findsNothing);
  // });
  //
  // testWidgets('Editable input should  accept input', (WidgetTester tester) async {
  //   //given
  //   await prepareWidget(
  //     tester,
  //     (context) => BasicTextInput.basicTextInput(
  //       context: context,
  //       keyString: 'testInput',
  //       label: 'Test Input',
  //       autovalidateMode: AutovalidateMode.onUserInteraction,
  //       labelPosition: LabelPosition.topLeft,
  //       formManager: TestFormManager.testDefault(),
  //       readonly: false,
  //     ),
  //   );
  //
  //   final inputField = find.byType(FormBuilderTextField);
  //
  //   //when
  //   await tester.enterText(inputField, userText);
  //   await tester.pump();
  //
  //   //then
  //   expect(find.text(userText), findsOne);
  // });
}
