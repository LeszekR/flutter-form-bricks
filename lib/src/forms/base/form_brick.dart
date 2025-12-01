import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/src/form_fields/base/form_field_brick.dart';

import '../../annotations/auto_form_schema.dart';
import '../../string_literals/gen/bricks_localizations.dart';
import '../form_manager/form_manager.dart';

///  Top layer of forms used by this software.
///  Can be used for forms that are not intended to save any data to db
@AutoFormSchema()
abstract class FormBrick extends StatefulWidget {
  final String _errorTextKeyString = 'error_text_area';
  final FormManager _formManager;

  FormBrick({super.key, required FormManager formManager}) : _formManager = formManager;

  get errorKeyString => _errorTextKeyString;

  GlobalKey<FormStateBrick> get formKey => _formManager.formKey;

  @override
  FormStateBrick createState();

  static Future<dynamic> openForm({required BuildContext context, required Widget form}) {
    return showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => form);
  }
}

/// A type alias for a map of form fields.
typedef FormFieldBrickFieldsMap = Map<String, FormFieldStateBrick<FormFieldBrick, dynamic, dynamic>>;

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

  final _formKey = GlobalKey<FormStateBrick>();

  GlobalKey<FormStateBrick> get formKey => formManager.formKey;

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

  @AutoFormSchema()
  @override
  Widget build(BuildContext context) {
    // TODO make focusedKeyString actually request focus
    return AnimatedBuilder(
      animation: formManager,
      // TODO - check this for correctness
      builder: (context, _) => buildBody(context),
    );
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

  @override
  void dispose() {
    // TODO uncomment and refactor
    // KeyboardEvents().unSubscribe(keyBoardActions);
    super.dispose();
  }

  Widget createFormControlPanel(
    BuildContext context,
  ) {
    // TODO uncomment and refactor
    return SizedBox(
      width: 100,
      height: 100,
    );
    // // return FormUtils.horizontalFormGroup(padding:false,height: AppSize.bottomPanelHeight + 1, [
    // return FormUtils.horizontalFormGroupBorderless(height: AppSize.bottomPanelHeight, [
    //   Expanded(
    //     flex: 6,
    //     child: ValueListenableBuilder<String>(
    //       valueListenable: formManager.errorMessageNotifier,
    //       builder: (context, errors, child) {
    //         return SingleChildScrollView(
    //           child: Container(
    //             height: AppSize.bottomPanelHeight,
    //             padding: EdgeInsets.all(AppSize.paddingForm),
    //             child: Text(
    //               errors,
    //               key: Key(widget._errorTextKeyString),
    //               softWrap: true,
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    //   //
    //   AppSize.spacerBoxHorizontalMedium,
    //   //
    //   Container(
    //     height: AppSize.bottomPanelHeight,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         /*decoration:  BoxDecoration(border: Border.all(width: AppSize.borderWidth, color: AppColor.borderEnabled)),*/
    //         /*child:*/
    //         SizedBox(
    //           height: AppSize.bottomPanelHeight - AppSize.buttonHeight - testControlsHeightCorrection(),
    //           width: 50,
    //         ),
    //         // FormUtils.horizontalFormGroup(padding: false,
    //         FormUtils.horizontalFormGroupBorderless(
    //           createFormControlsList(),
    //         ),
    //       ],
    //     ),
    //   ),
    // ]);
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
