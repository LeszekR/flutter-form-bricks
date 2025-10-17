import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/shelf.dart';

class ExampleSingleForm extends SingleForm {
  ExampleSingleForm({super.key});

  @override
  SingleFormState<SingleForm> createState() => _ExampleSingleFormState();
}

class _ExampleSingleFormState extends SingleFormState<ExampleSingleForm> {
  void trimGroupOfFieldsWhenFocusLost(List<String> keyStrings) {
    for (var keyString in keyStrings) {
      FocusNode focusNode = formManager.getFocusNode(keyString);
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          var editingController = formManager.getTextEditingController(keyString);
          FormatterHelper.onSubmittedTrimming(editingController.text, editingController);
        }
      });
    }
  }

  @override
  void dispose() {
    formManager.disposeAll();
    super.dispose();
  }

  @override
  String provideLabel() => "Przykład Single Form";

  @override
  void submitData() {
    final Map<String, dynamic> formData = formManager.collectInputData();
    debugPrint("save triggered. Data: $formData");
  }

  @override
  void deleteEntity() => debugPrint("delete triggered");

  // @override
  // Entity? getEntity() => null;
  //
  // @override
  // EntityService<Entity> getService() => throw UnimplementedError();

  @override
  void removeEntityFromState() {}

  @override
  void upsertEntityInState(Map<String, dynamic> responseBody) {}

  //choice
  var _dependentTextInputReadonly = false;
  var _doingNothing = false;

  @override
  List<Widget> createBody(BuildContext context) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    return [
      _createTextPart(appSize),
      appSize.spacerBoxVerticalSmall,
      //
      _createChoicesPart(appSize),
      appSize.spacerBoxVerticalSmall,
      //
      _createNumbersPart(appSize),
      appSize.spacerBoxVerticalSmall,
      //
      _createDatesPart(appSize),
      appSize.spacerBoxVerticalSmall,
      //
      _createDateHourPart(),
      appSize.spacerBoxHorizontalSmall,
      //
      _createDateHourPartWithOneField(),
      appSize.spacerBoxHorizontalSmall,
    ];
  }

  Container _createTextPart(AppSize appSize) {
    String testSimpleKeyString = "regular_input_standalone";
    String lowerCaseTextKeyString = "2 lowercase text";
    String withDefaultKeyString = "withDefault_standalone";
    String upperCaseKeyString = "5 uppercase text";
    String firstUpperCaseKeyString = "first_uppercase_text_standalone 1";
    String vatKeyString = "vat_standalone 1";
    String upperCaseKeyString2 = "6 uppercase text";
    String firsUpperCaseKeyString2 = "first_uppercase_text_standalone 2";
    String vatKeyString2 = "vat_standalone 2";
    String multilineKeyString = "4 bulkText";
    String multilineWithButtonKeyString = "6 bulkText";

    List<String> keyStringsForText = [
      testSimpleKeyString,
      lowerCaseTextKeyString,
      withDefaultKeyString,
      upperCaseKeyString,
      firstUpperCaseKeyString,
      vatKeyString,
      upperCaseKeyString2,
      firsUpperCaseKeyString2,
      vatKeyString2,
      multilineKeyString,
      multilineWithButtonKeyString
    ];

    trimGroupOfFieldsWhenFocusLost(keyStringsForText);

    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BasicTextInput.label("Label - tylko odczyt", appSize.fontSize5),
        appSize.spacerBoxVerticalSmall,
        //
        TextInputs.textSimple(
          keyString: testSimpleKeyString,
          label: 'Prosty text input',
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
          validator: ValidatorProvider.compose(isRequired: true),
          withTextEditingController: true,
          onEditingComplete: () {},
          textInputAction: TextInputAction.none,
        ),
        appSize.spacerBoxVerticalSmall,
        //
        TextInputs.textLowercase(
          keyString: lowerCaseTextKeyString,
          label: 'tylko low-case',
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
          initialValue: 'gucio',
        ),
        appSize.spacerBoxVerticalSmall,
        //
        TextInputs.textSimple(
          keyString: withDefaultKeyString,
          label: 'input posiadający defaultową wartość (sprawdz reset)',
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
        ),
        appSize.spacerBoxVerticalSmall,
        //
        TextInputs.textMultiline(
          keyString: multilineKeyString,
          label: 'Bulk Text',
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
          inputWidth: appSize.textFieldWidth * 2,
          inputHeightMultiplier: 2,
        )
      ],
    );
    //
    final middleColumn = Column(
      children: [
        TextInputs.textUppercase(
          keyString: upperCaseKeyString,
          label: 'tylko upper-case',
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
        ),
        appSize.spacerBoxVerticalSmall,
        //
        TextInputs.textSimple(
          keyString: firstUpperCaseKeyString,
          label: 'pierwszy upper, potem lower',
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
        ),
        appSize.spacerBoxVerticalSmall,
        //
        TextInputs.textVat(
          keyString: vatKeyString,
          label: 'Text input z regexem VAT',
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
        ),
      ],
    );
    //
    var inputWidth = appSize.textFieldWidth * 1.3;
    final rightColumn = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInputs.textUppercase(
          keyString: upperCaseKeyString2,
          label: 'tylko upper-case',
          labelPosition: ELabelPosition.left,
          formManager: formManager,
        ),
        appSize.spacerBoxVerticalSmall,
        //
        TextInputs.textFirstUppercaseThenLowercase(
          keyString: firsUpperCaseKeyString2,
          label: 'pierwszy upper, potem lower',
          labelPosition: ELabelPosition.left,
          formManager: formManager,
          inputWidth: inputWidth,
        ),
        appSize.spacerBoxVerticalSmall,
        //
        TextInputs.textVat(
          keyString: "vat_standalone 2",
          label: 'Text input z regexem VAT',
          labelPosition: ELabelPosition.left,
          formManager: formManager,
          inputWidth: inputWidth,
          // focusNode: formManager.getFocusNode('Text input z regexem VAT'),
          // textEditingController: formManager.getEditingController('Text input z regexem VAT'),
        ),
        appSize.spacerBoxVerticalSmall,
        //
        TextInputs.textMultilineWithButton(
          keyString: multilineWithButtonKeyString,
          label: 'Multiline text',
          labelPosition: ELabelPosition.left,
          formManager: formManager,
          iconData: Icons.arrow_drop_down,
          onPressed: (() => Dialogs.informationDialog(context, 'GUZIK', 'Naciśnięto')),
          tooltip: 'Otwórz coś',
          inputWidth: inputWidth,
          inputHeightMultiplier: 3,
        ),
        appSize.spacerBoxVerticalSmall,
        //
        TextInputs.textMultiline(
          keyString: multilineWithButtonKeyString,
          label: 'Multiline text',
          labelPosition: ELabelPosition.left,
          formManager: formManager,
          inputWidth: inputWidth,
          inputHeightMultiplier: 2,
        )
      ],
    );
    return FormUtils.horizontalFormGroup([
      leftColumn,
      appSize.spacerBoxHorizontalMedium,
      middleColumn,
      appSize.spacerBoxHorizontalMedium,
      rightColumn,
    ], label: "Tekst", alignment: Alignment.topLeft);
  }

  Container _createNumbersPart(AppSize appSize) {
    final numbers = FormUtils.horizontalFormGroup([
      NumberInputs.textInteger(
        keyString: "text_integer",
        label: "Pole integer",
        labelPosition: ELabelPosition.topLeft,
        formManager: formManager,
      ),
      appSize.spacerBoxHorizontalMedium,
      appSize.spacerBoxHorizontalMedium,
      NumberInputs.textDouble(
        formManager: formManager,
        keyString: "double",
        label: "Pole double z dwoma miejscami po przecinku",
        labelPosition: ELabelPosition.topLeft,
      ),
    ], label: "Liczby");
    return numbers;
  }

  Container _createChoicesPart(AppSize appSize) {
    return FormUtils.horizontalFormGroup([
      appSize.spacerBoxHorizontalMedium,
      FormUtils.verticalFormGroup(
        [
          appSize.spacerBoxVerticalSmall,
          CheckboxCustom(
              keyString: "checkbox_standalone_1",
              label: "checkbox blokujący pole",
              initialValue: _dependentTextInputReadonly,
              width: appSize.textFieldWidth * 0.8,
              labelLeftOfCheckbox: true,
              onChanged: (val) => setState(() => _dependentTextInputReadonly = val ?? false)),
          CheckboxCustom(
              keyString: "checkbox_standalone_2",
              label: "checkbox, co nic nie robi",
              initialValue: _doingNothing,
              width: appSize.textFieldWidth * 0.8,
              labelLeftOfCheckbox: true,
              onChanged: (val) => setState(() => _doingNothing = val ?? false)),
        ],
        padding: false,
        borderTop: false,
        borderLeft: false,
        borderBottom: false,
        borderRight: false,
      ),
      appSize.spacerBoxHorizontalMedium,
      TextInputs.textSimple(
          keyString: "fieldDenpendentOnCheckbox_standalone",
          label: 'Text input zależny od checkbox',
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
          readonly: _dependentTextInputReadonly),
      appSize.spacerBoxHorizontalMedium,
      appSize.spacerBoxHorizontalMedium,
      ChoiceInputs.radio(
        options: {"radio_1": "opcja pierwsza", "radio_2": "opcja druga"},
        id: "checkboxKey",
        groupLabel: "Radio buttons",
        labelOnTheLeft: true,
        width: appSize.textFieldWidth * 0.6,
        validator: ValidatorProvider.compose(isRequired: true),
        formManager: formManager,
      ),
    ], label: "Inputy wyborów", height: appSize.labelHeight + appSize.textFieldWidth * 4);
  }

  Container _createDateHourPart() {
    final dates = FormUtils.verticalFormGroup([
      DateTimeInputs.dateTimeSeparateFields(
          keyString: "date_time_1",
          label: "Data i godzina",
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
          context: context),
    ], label: 'Date hour');

    return dates;
  }

  Container _createDatesPart(AppSize appSize) {
    final dates = FormUtils.verticalFormGroup([
      //
      DateTimeInputs.date(
          keyString: "dateonly",
          label: "Sama Data",
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
          context: context),
      appSize.spacerBoxVerticalSmall,
      //
      DateTimeInputs.time(
          keyString: "timeonly",
          label: "Sam Czas",
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
          context: context),
      appSize.spacerBoxVerticalSmall,
      //
      DateTimeInputs.dateTimeSeparateFields(
          keyString: "date_time_2",
          label: "Data odbioru",
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
          context: context),
      appSize.spacerBoxVerticalSmall,
      //
      DateTimeInputs.dateTimeRange(
          rangeId: "date_time_range_1",
          label: "Załadunek dla klienta",
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
          context: context)
    ], label: "Daty");
    return dates;
  }

  Container _createDateHourPartWithOneField() {
    final dates = FormUtils.verticalFormGroup([
      DateTimeInputs.dateTimeOneField(
          keyString: "DateHourKey",
          label: "Data i godzina",
          labelPosition: ELabelPosition.topLeft,
          formManager: formManager,
          context: context)
    ], label: "Date and hour with one field");

    return dates;
  }
}
