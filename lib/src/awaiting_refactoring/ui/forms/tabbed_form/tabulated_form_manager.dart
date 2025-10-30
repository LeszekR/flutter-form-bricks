import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/form_manager/form_manager_OLD.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'tab_data.dart';
import 'tab_status.dart';

class TabulatedFormManager extends FormManagerOLD {
  final ValueNotifier<Map<String, TabStatus>> tabStatusNotifier = ValueNotifier<Map<String, TabStatus>>({});
  GlobalKey<FormBuilderState>? _currentTabGlobalKey;
  final Map<GlobalKey<FormBuilderState>, TabData> tabsDataMap = {};

  TabulatedFormManager();

  @override
  void fillInitialInputValuesMap() {
    for (var tabData in tabsDataMap.values) {
      setInitialValues(tabData.globalKey);
    }
  }

  @override
  void afterFieldChanged() {
    calculateTabStatus(_currentTabGlobalKey!);
    _notifyTabStatusChange();
  }

  @override
  FormStatus checkStatus() {
    final activeTabsData =
        tabsDataMap.entries.where((entry) => tabsDataMap[entry.key]!.currentStatus != TabStatus.tabDisabled);

    var hasInvalidTab =
        activeTabsData.any((tabData) => getFormPartState(tabData.value.globalKey) == FormStatus.invalid);
    if (hasInvalidTab) return FormStatus.invalid;

    var hasValidTab = activeTabsData.any((tabData) => getFormPartState(tabData.value.globalKey) == FormStatus.valid);
    if (hasValidTab) return FormStatus.valid;

    return FormStatus.noChange;
  }

  @override
  void resetForm() {
    for (var tabData in tabsDataMap.values) {
      // TODO refactor to FlutterFormBuilder pattern - ?
      // tabData.globalKey.currentState?.reset();
      // tabData.globalKey.currentState?.validate();
      tabData.currentStatus = tabData.initialStatus;
    }
    calculateAllTabsStatuses();
  }

  @override
  Map<String, dynamic> collectInputs() {
    // TODO refactor to FlutterFormBuilder pattern - ?
    return {};
    // final Map<String, dynamic> inputs = {};
    // tabsDataMap.entries
    //     .where((entry) => !isTabDisabled(entry.value.globalKey))
    //     .forEach((entry) => inputs.addAll(entry.value.globalKey.currentState?.value as Map<String, dynamic>));
    // return inputs;
  }

  void addTabData(TabData tabData) {
    var globalKey = tabData.globalKey;
    if (tabsDataMap.containsKey(globalKey)) return;
    tabsDataMap[globalKey] = tabData;
  }

  @override
  FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>? findField(String keyString) {
    // TODO refactor to FlutterFormBuilder pattern - ?
    _setCurrentTab(keyString);
    return _currentTabGlobalKey!.currentState?.fields[keyString];
  }

  void _setCurrentTab(String keyString) {
    if (_currentTabGlobalKey?.currentState?.fields.containsKey(keyString) ?? false) {
      return;
    }
    _currentTabGlobalKey = tabsDataMap.entries
        .where((entry) => entry.value.globalKey.currentState?.fields.containsKey(keyString) ?? false)
        .map((entry) => entry.value.globalKey)
        .first;
  }

  void calculateTabStatus(GlobalKey<FormBuilderState> globalKey) {
    if (isTabDisabled(globalKey)) {
      return;
    }
    if (tabsDataMap[globalKey]?.globalKey.currentState?.isValid ?? false) {
      tabsDataMap[globalKey]!.currentStatus = TabStatus.tabOk;
    } else {
      tabsDataMap[globalKey]!.currentStatus = TabStatus.tabError;
    }
  }

  void calculateAllTabsStatuses() {
    tabsDataMap.forEach((globalKey, value) => calculateTabStatus(globalKey));
    _notifyTabStatusChange();
  }

  void _notifyTabStatusChange() {
    tabStatusNotifier.value = Map.fromEntries(
        tabsDataMap.entries.map((entry) => MapEntry(entry.value.globalKey.toString(), entry.value.currentStatus)));
  }

  void setDisabled(GlobalKey<FormBuilderState> globalKey, bool isLockedNow) {
    var tabData = tabsDataMap[globalKey]!;

    if (isLockedNow) {
      tabData.currentStatus = TabStatus.tabDisabled;
    } else if (tabData.globalKey.currentState?.isValid ?? false) {
      tabData.currentStatus = TabStatus.tabOk;
    } else {
      tabData.currentStatus = TabStatus.tabError;
    }
    _notifyTabStatusChange();
  }

  bool isTabDisabled(GlobalKey<FormBuilderState> globalKey) {
    return tabsDataMap[globalKey]!.currentStatus == TabStatus.tabDisabled;
  }
}
