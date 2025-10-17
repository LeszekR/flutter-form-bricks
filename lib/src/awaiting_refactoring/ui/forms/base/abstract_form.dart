import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../buttons/buttons.dart';
import '../../dialogs/dialogs.dart';
import '../form_manager/form_manager.dart';
import '../form_manager/form_state.dart';
import 'form_utils.dart';

///  Top layer of forms used by this software.
///  Can be used for forms that are not intended to save any data to db
abstract class AbstractForm extends StatefulWidget {
  final String _errorTextKeyString = "error_text";

  get errorkeyString => _errorTextKeyString;

  final FormManagerOLD _formManager;

  FormManagerOLD get formManager => _formManager;

  GlobalKey<FormBuilderState> get formKey => _formManager.formKey;

  const AbstractForm({super.key, required FormManagerOLD formManager}) : _formManager = formManager;

  @override
  AbstractFormState createState();

  static Future<dynamic> openForm({required final BuildContext context, required final Widget form}) {
    return showDialog(context: context, barrierDismissible: false, builder: (final BuildContext context) => form);
  }
}

abstract class AbstractFormState<T extends AbstractForm> extends State<T> {
  /// Do NOT override this method in PROD! This is ONLY FOR UI TESTS!
  /// Flutter builds UI differently in prod and test. Due to that TestStandaloneForm crashes on control panel vertical
  /// overflow without this correction, This param introduces correction of control panel height
  int testControlsHeightCorrection() => 0;

  // TU PRZERWAŁEM - dokończyć uruchomienie example - potem refactoring do lib
  late final ApplicationState applicationState;
  late final Map<int, VoidCallback> _keyboardMapping;

  FormManagerOLD get formManager => widget._formManager;

  GlobalKey<FormBuilderState> get formKey => formManager.formKey;

  String provideLabel();

  void deleteEntity();

  void submitData();

  /// If you need to have a process after form is initiated, this is your place to go
  void postConstruct() {}

  @override
  void initState() {
    super.initState();
    _keyboardMapping = provideKeyboardActions();
    KeyboardEvents().subscribe(keyBoardActions);
    applicationState = Provider.of<ApplicationState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postConstruct();
      formManager.fillInitialInputValuesMap();
    });
  }

  void keyBoardActions(final RawKeyEvent event) {
    // TODO migrate to new flutter: https://docs.flutter.dev/release/breaking-changes/key-event-migration
    if (event.isShiftPressed) {
      return;
    }
    final ctrlPrefix = event.isControlPressed ? LogicalKeyboardKey.control.keyId : 0;
    _keyboardMapping[ctrlPrefix + event.logicalKey.keyId]?.call();
  }

  Map<int, VoidCallback> provideKeyboardActions() {
    return {
      // LogicalKeyboardKey.escape.keyId: () => onCancel(),
      // TODO make focus move to next field
      // LogicalKeyboardKey.enter.keyId: () => onSubmit(),
    };
  }

  @override
  void dispose() {
    KeyboardEvents().unSubscribe(keyBoardActions);
    super.dispose();
  }

  Widget createFormControlPanel(
    final BuildContext context,
  ) {
    // return FormUtils.horizontalFormGroup(padding:false,height: AppSize.bottomPanelHeight + 1, [
    return FormUtils.horizontalFormGroupBorderless(height: AppSize.bottomPanelHeight, [
      Expanded(
        flex: 6,
        child: ValueListenableBuilder<String>(
          valueListenable: formManager.errorMessageNotifier,
          builder: (context, errors, child) {
            return SingleChildScrollView(
              child: Container(
                height: AppSize.bottomPanelHeight,
                padding: EdgeInsets.all(AppSize.paddingForm),
                child: Text(
                  errors,
                  key: Key(widget._errorTextKeyString),
                  softWrap: true,
                ),
              ),
            );
          },
        ),
      ),
      //
      AppSize.spacerBoxHorizontalMedium,
      //
      Container(
        height: AppSize.bottomPanelHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*decoration:  BoxDecoration(border: Border.all(width: AppSize.borderWidth, color: AppColor.borderEnabled)),*/
            /*child:*/
            SizedBox(
              height: AppSize.bottomPanelHeight - AppSize.buttonHeight - testControlsHeightCorrection(),
              width: 50,
            ),
            // FormUtils.horizontalFormGroup(padding: false,
            FormUtils.horizontalFormGroupBorderless(
              createFormControlsList(),
            ),
          ],
        ),
      ),
    ]);
  }

  List<Widget> createFormControlsList() {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        saveButton(),
        AppSize.spacerBoxHorizontalSmall,
        resetButton(),
        AppSize.spacerBoxHorizontalSmall,
        deleteButton(),
        AppSize.spacerBoxHorizontalSmall,
        cancelButton(),
      ])
    ];
  }

  Widget deleteButton() =>
      Buttons.elevatedButton(text: Tr.get.delete, onPressed: isEditMode() ? onDelete : () {}, isEnabled: isEditMode());

  Widget cancelButton() => Buttons.elevatedButton(text: Tr.get.buttonCancel, onPressed: onCancel);

  Widget resetButton() => Buttons.elevatedButton(text: Tr.get.reset, onPressed: onReset);

  Widget saveButton() => Buttons.elevatedButton(text: Tr.get.save, onPressed: onSubmit);

  void onReset() =>
      Dialogs.decisionDialogYesNo(context, Tr.get.formReset, Tr.get.formResetConfirm, action: formManager.resetForm);

  void onCancel() =>
      Dialogs.decisionDialogYesNo(context, Tr.get.buttonCancel, Tr.get.pagesAbstractFormDialogsConfirmCancel,
          action: cancel);

  void cancel() => Navigator.of(context).pop(false);

  void onDelete() =>
      Dialogs.decisionDialogOkCancel(context, Tr.get.dialogsWarning, Tr.get.deleteConfirm, action: deleteEntity);

  void onTab() => TextInputAction.next;

  onSubmit() {
    final formState = formManager.checkState();

    switch (formState) {
      case FormStatus.noChange:
        Dialogs.informationDialog(
            context,
            Tr.get.dialogsError,
            isEditMode()
                ? Tr.get.pagesAbstractFormDialogsErrorNoChanges
                : Tr.get.pagesAbstractFormDialogsErrorCorrectContent);
        break;
      case FormStatus.invalid:
        Dialogs.informationDialog(context, Tr.get.dialogsError, Tr.get.pagesAbstractFormDialogsErrorCorrectContent);
        break;
      case FormStatus.valid:
        submitData();
        break;
    }
  }

  bool isEditMode() {
    return false;
  }
}
