import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/form_field_brick.dart';
import 'package:flutter_form_bricks/src/forms/base/form_ui_update_coordinator.dart';
import 'package:flutter_form_bricks/src/forms/base/form_ui_update_scope.dart';

import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';

import '../../awaiting_refactoring/ui/forms/base/form_utils.dart';
import '../../string_literals/gen/bricks_localizations.dart';
import '../form_manager/form_manager.dart';

/// A type alias for a map of form fields.
typedef FormFieldBrickFieldsMap = Map<String, FormFieldStateBrick<FormFieldBrick, dynamic, dynamic>>;

///  Top layer of forms used by this software.
///  Can be used for forms that are not intended to save any data to db
abstract class FormBrick extends StatefulWidget {
  final String _errorTextKeyString = 'error_text_area';
  final FormManager _formManager;

  FormBrick({super.key, required FormManager formManager}) : _formManager = formManager;

  get errorKeyString => _errorTextKeyString;

  GlobalKey<FormStateBrick> get formKey => _formManager.formKey;

  @override
  FormStateBrick createState();

  // TODO  is it needed? Remove?
  static Future<dynamic> openForm({required BuildContext context, required Widget form}) {
    return showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => form);
  }
}

abstract class FormStateBrick<T extends FormBrick> extends State<T> {
  /// Do NOT override this method in PROD! This is ONLY FOR UI TESTS!
  /// Flutter builds UI differently in prod and test. Due to that TestSingleForm crashes on control panel vertical
  /// overflow without this correction, This param introduces correction of control panel height
  int testControlsHeightCorrection() => 0;

  // TODO refactor? to FlutterFormBuilder pattern?
  // TODO fill the map? or remove it?
  final Map<String, FormFieldStateBrick> fields = {};

  late final Map<int, VoidCallback> _keyboardMapping;

  FormManager get formManager => widget._formManager;

  GlobalKey<FormStateBrick> get formKey => formManager.formKey;

  late final FormUiUpdateCoordinator _formUiUpdateCoordinator;

  // TODO implement in implementations of this class mimcking FlutterFormBuilder
  // TODO move to FormManager?
  // bool get isValid;

  void submitData();

  /// If you need to have a process after form is initiated, this is your place to go
  void postConstruct() {}

  Widget buildBody(BuildContext context);

  @override
  void initState() {
    super.initState();
    _keyboardMapping = provideKeyboardActions();
    _formUiUpdateCoordinator = FormUiUpdateCoordinator();
    // TODO uncomment and refactor
    // KeyboardEvents().subscribe(keyBoardActions);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postConstruct();
    });
  }

  @mustCallSuper
  @override
  void didChangeDependencies() {
    formManager.localizations = BricksLocalizations.of(context);
    formManager.validateForm();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _formUiUpdateCoordinator.dispose();
    // TODO uncomment and refactor
    // KeyboardEvents().unSubscribe(keyBoardActions);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO make focusedKeyString actually request focus
    return FormUiUpdateScope(
      coordinator: _formUiUpdateCoordinator,
      child: AnimatedBuilder(
        key: widget.formKey,
        animation: formManager,
        builder: (context, _) =>
            SizedBox.expand(
              child: Column(
                children: [
                  Expanded(child: buildBody(context)),
                  buildFormControlPanel(context),
                ],
              ),
            ),
      ),);
  }

  void keyBoardActions(RawKeyEvent event) {
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

  /// Builds a widget that displays error messages for the currently focused field.
  ///
  /// The widget listens to `formManager.errorMessageNotifier`
  /// and rebuilds whenever its value changes.
  ///
  /// The error message:
  /// - is wrapped (`softWrap`)
  /// - is placed inside a `SingleChildScrollView`
  /// - uses styling from `UiParams`
  Widget buildErrorDisplayArea(BuildContext context) {
    var uiParams = UiParams.of(context);
    return Container(
      constraints: BoxConstraints.expand(),
      padding: EdgeInsets.all(uiParams.appSize.paddingForm),
      // TODO 1 global error-area background color
      decoration: BoxDecoration(color: uiParams.appColor.greyLightest),
      child: SingleChildScrollView(
        child: ValueListenableBuilder<String>(
          valueListenable: formManager.errorMessageNotifier,
          builder: (context, errors, child) =>
              Text(
                errors,
                key: Key(widget._errorTextKeyString),
                softWrap: true,
                style: TextStyle(color: uiParams.appColor.textError),
              ),
        ),
      ),
    );
  }

  Widget buildFormControlPanel(BuildContext context,) {
    var appSize = UiParams
        .of(context)
        .appSize;

    // return FormUtils.horizontalFormGroup(padding:false,height: AppSize.bottomPanelHeight + 1, [
    return FormUtils.horizontalFormGroupBorderless(
      context,
      [
        Expanded(
          flex: 6,
          child: Container(
              height: appSize.bottomPanelHeight,
              padding: EdgeInsets.all(appSize.paddingForm),
              child: buildErrorDisplayArea(context)),
        ),
        //
        // appSize.spacerBoxHorizontalMedium,
        // //
        // Container(
        //   height: appSize.bottomPanelHeight,
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       /*decoration:  BoxDecoration(border: Border.all(width: appSize.borderWidth, color: AppColor.borderEnabled)),*/
        //       /*child:*/
        //       SizedBox(
        //         height: appSize.bottomPanelHeight - appSize.buttonHeight - testControlsHeightCorrection(),
        //         width: 50,
        //       ),
        //       // FormUtils.horizontalFormGroup(padding: false,
        //       FormUtils.horizontalFormGroupBorderless(
        //         createFormControlsList(),
        //       ),
        //     ],
        //   ),
        // ),
      ],
      height: appSize.bottomPanelHeight,
    );
  }

  // TODO uncomment and refactor
  // List<Widget> createFormControlsList() {
  //   return [
  //     Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       saveButton(),
  //       AppSize.spacerBoxHorizontalSmall,
  //       resetButton(),
  //       AppSize.spacerBoxHorizontalSmall,
  //       deleteButton(),
  //       AppSize.spacerBoxHorizontalSmall,
  //       cancelButton(),
  //     ])
  //   ];
  // }

  // TODO uncomment and refactor
  // Widget deleteButton() =>
  //     Buttons.elevatedButton(text: localizations.delete, onPressed: isEditMode() ? onDelete : () {}, isEnabled: isEditMode());
  //
  // Widget cancelButton() => Buttons.elevatedButton(text: localizations.buttonCancel, onPressed: onCancel);
  //
  // Widget resetButton() => Buttons.elevatedButton(text: localizations.reset, onPressed: onReset);
  //
  // Widget saveButton() => Buttons.elevatedButton(text: localizations.save, onPressed: onSubmit);
  //
  // void onReset() =>
  //     Dialogs.decisionDialogYesNo(context, localizations.formReset, localizations.formResetConfirm, action: formManager.resetForm);
  //
  // void onCancel() =>
  //     Dialogs.decisionDialogYesNo(context, localizations.buttonCancel, localizations.pagesAbstractFormDialogsConfirmCancel,
  //         action: cancel);
  //
  // void cancel() => Navigator.of(context).pop(false);
  //
  // void onDelete() =>
  //     Dialogs.decisionDialogOkCancel(context, localizations.dialogsWarning, localizations.deleteConfirm, action: deleteEntity);
  //
  // void onTab() => TextInputAction.next;
  //
  // onSubmit() {
  //   final formState = formManager.checkState();
  //
  //   switch (formState) {
  //     case EFormStatus.noChange:
  //       Dialogs.informationDialog(
  //           context,
  //           localizations.dialogsError,
  //           isEditMode()
  //               ? localizations.pagesAbstractFormDialogsErrorNoChanges
  //               : localizations.pagesAbstractFormDialogsErrorCorrectContent);
  //       break;
  //     case EFormStatus.invalid:
  //       Dialogs.informationDialog(context, localizations.dialogsError, localizations.pagesAbstractFormDialogsErrorCorrectContent);
  //       break;
  //     case EFormStatus.valid:
  //       submitData();
  //       break;
  //   }
  // }

  bool isEditMode() {
    return false;
  }
}
