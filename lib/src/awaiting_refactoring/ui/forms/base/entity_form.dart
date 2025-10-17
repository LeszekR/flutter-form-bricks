import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shipping_ui/config/objects/abstracts/entity.dart';

import '../../../../config/http/http_service.dart';
import '../../../../config/http/server_response.dart';
import '../../../../config/string_assets/translation.dart';
import '../../dialogs/dialogs.dart';
import '../../../config/editing_lock/model/lock_response.dart';
import '../../../config/editing_lock/service/editing_lock_service.dart';
import 'abstract_form.dart';

/// Net layer of abstract designed for managing CRUD of DB Entities.
/// IMPORTANT NOTE this layer supports locking of db Entities.
abstract class EntityForm extends AbstractForm {
  const EntityForm({super.key, required super.formManager});
}

abstract class EntityFormState<T extends EntityForm> extends AbstractFormState<T> {
  static final _entityLockTimeoutSec = GlobalConfiguration().getValue<int>("entityLockTimeoutSec");

  DateTime? lockDeadline;
  Timer? _warnTimer;

  // Entity? getEntity();
  //
  // EntityService getService();

  void removeEntityFromState();

  void upsertEntityInState(final Map<String, dynamic> responseBody);

  @override
  void postConstruct() {
    super.postConstruct();
    if (isEditMode()) {
      setLock();
    }
  }

  @override
  void dispose() {
    _warnTimer?.cancel();
    EditingLockService().releaseLock().then((response) => lockDeadline = null);
    super.dispose();
  }

  @override
  bool isEditMode() => getEntity() != null;

  /*
  * For most cases API handles upsert with one POST endpoint but for cases when it is divided into POST/PUT you need
  * to override the method
  * */
  bool hasOneUpsertEndpoint() => true;

  void setLock() {
    EditingLockService().setLock(entity: getEntity(), contextForSpinner: context).then((response) {
      if (response.isFaulty) {
        cancel();
        Dialogs.informationDialog(context, Tr.get.dialogsWarning, response.errorMessage!);
      } else {
        final lockData = LockResponse.fromJson(response.getJson!);
        setDeadline(lockData.lockEnd);
      }
    });
  }

  void setDeadline(final DateTime fromBackend) {
    setState(() => lockDeadline = fromBackend);
    // Cancel any existing timers
    final warnDuration = lockDeadline!.subtract(Duration(seconds: _entityLockTimeoutSec)).difference(DateTime.now());
    _warnTimer?.cancel();
    _warnTimer = Timer(warnDuration, () => _warnDeadlineSoon());
  }

  void _warnDeadlineSoon() {
    final message = Tr.get.pagesEntityFormErrorMessageName;
    Dialogs.decisionDialogOkCancel(context, Tr.get.dialogsWarning, message).then((userWantsToContinue) {
      userWantsToContinue ? setLock() : Navigator.of(context, rootNavigator: true).pop(false);
    });
  }

  void closeFormAfterUpsert({final bool? requestTableDataRefresh = true}) {
    if (isEditMode()) {
      EditingLockService().releaseLock().then((response) => lockDeadline = null);
    }
    Navigator.pop(context, requestTableDataRefresh);
  }

  @override
  void submitData() {
    _upsert().then((response) {
      if (response.isOk) {
        Dialogs.informationDialog(context, Tr.get.dialogsSuccess, Tr.get.dialogsSaveSuccess).then((voidVal) {
          upsertEntityInState(response.getJson!);
          closeFormAfterUpsert();
        });
      } else {
        Dialogs.informationDialog(context, Tr.get.dialogsWarning, response.errorMessage!);
      }
    });
  }

  Future<ServerResponse> _upsert() {
    final Map<String, dynamic> formData = formManager.collectInputData();
    return isEditMode() && !hasOneUpsertEndpoint() ? _put(formData) : _post(formData);
  }

  Future<ServerResponse> _post(final Map<String, dynamic> formData) {
    return getService().post(entity: formData, contextForSpinner: context);
  }

  Future<ServerResponse> _put(final Map<String, dynamic> formData) {
    return getService().put(entity: formData, contextForSpinner: context);
  }

  @override
  void deleteEntity() {
    getService().delete(entity: getEntity()!, contextForSpinner: context).then((response) {
      if (response.isOk) {
        Dialogs.informationDialog(context, Tr.get.dialogsSuccess, Tr.get.dialogsDeleteSuccess).then((res) {
          removeEntityFromState();
          Navigator.pop(context, true);
        });
      } else {
        Dialogs.informationDialog(context, Tr.get.dialogsWarning, response.errorMessage!);
        formManager.addErrorMessageIfIsNew(Tr.get.pagesEntityFormErrorMessageName, response.errorMessage!);
      }
    });
  }
}
