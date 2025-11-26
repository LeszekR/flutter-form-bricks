import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../../shelf.dart';
import 'tabulated_form_manager.dart';

abstract class TabulatedForm extends AbstractForm {
  TabulatedForm({super.key, required FormData stateData, required FormSchema schema})
      : super(formManager: TabulatedFormManager(formData: stateData, formSchema: schema));
}

abstract class TabulatedFormState<T extends TabulatedForm> extends AbstractFormState<T>
    with SingleTickerProviderStateMixin {
  List<TabData> makeTabsData();

  @override
  TabulatedFormManager get formManager => super.formManager as TabulatedFormManager;

  final _tabsDataList = [];
  final Map<GlobalKey<FormBuilderState>, Widget> _tabsContent = {};

  int _currentTabIndex = 0;
  TabController? _tabController;

  @override
  void initState() {
    _tabsDataList.addAll(makeTabsData());
    formManager.tabsDataMap
        .addAll(Map.fromEntries(_tabsDataList.map((tabData) => MapEntry(tabData.globalKey, tabData))));
    _setInitialTabIndex();
    _tabController = TabController(length: _tabsDataList.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormUtils.defaultScaffold(
      context: context,
      label: provideLabel(),
      child: Column(
        children: [
          _createFormBody(context),
          UiParams.of(context).appSize.spacerBoxVerticalSmall,
          createFormControlPanel(context),
        ],
      ),
    );
  }

  //initial tab state has to be called here so the form is aware of all children form_fields and able to tell us if any validation failed
  @override
  void postConstruct() {
    super.postConstruct();
    setState(() => formManager.calculateAllTabsStatuses());
  }

  void _setInitialTabIndex() {
    for (int i = 0; i < _tabsDataList.length; i++) {
      if (_tabsDataList[i].initialStatus != TabStatus.tabDisabled) {
        _currentTabIndex = i;
        break;
      }
    }
    assert((_currentTabIndex >= 0), 'At least one active tab is required');
  }

  List<Widget> _makeTabsContent() {
    for (int i = 0; i < _tabsDataList.length; i++) {
      final tabData = _tabsDataList[i];
      _tabsContent[tabData.globalKey] = FormBuilder(
        autovalidateMode: AutovalidateMode.disabled,
        key: tabData.globalKey,
        child: tabData.makeTabContent(),
      );
    }
    return _tabsContent.values.toList();
  }

  TabBar _createTabBar(BuildContext context) {
    final uiParams = UiParams.of(context);
    final appSize = uiParams.appSize;
    final appStyle = uiParams.appStyle;
    final appColor = uiParams.appColor;
    final List<Tab> tabs = [];

    for (TabData tabData in _tabsDataList) {
      var globalKeyString = tabData.globalKey.toString();
      tabs.add(Tab(
        height: appSize.tabHeight,
        icon: ValueListenableBuilder<Map<String, TabStatus>>(
            valueListenable: formManager.tabStatusNotifier,
            builder: (BuildContext context, Map<String, TabStatus> observableMap, Widget? child) {
              final TabStatus tabStatus = observableMap[globalKeyString] ?? TabStatus.tabOk;
              return Container(
                key: Key(globalKeyString),
                decoration: BoxDecoration(
                  color: tabStatus.backgroundColor(appColor),
                  border: _getTabBorder(appStyle, tabData.globalKey),
                ),
                constraints: BoxConstraints(
                  minWidth: appSize.tabMinWidth,
                  minHeight: appSize.tabHeight,
                  maxHeight: appSize.tabHeight,
                ),
                padding: EdgeInsets.only(left: appSize.paddingTabsVertical, right: appSize.paddingTabsVertical),
                child: Center(
                  child: Text(
                    tabData.label,
                    style: TextStyle(color: tabStatus.fontColor(appColor), fontStyle: tabStatus.fontStyle(appStyle)),
                  ),
                ),
              );
            }),
      ));
    }

    return TabBar(
      key: const Key('tabBar'),
      padding: EdgeInsets.zero,
      controller: _tabController,
      isScrollable: true,
      tabs: tabs,
      onTap: (i) => {_switchTab(isDisabled: formManager.isTabDisabled(_tabsDataList[i]))},
    );
  }

  Widget _createFormBody(BuildContext context) {
    return DefaultTabController(
      length: _tabsDataList.length,
      child: Expanded(
        child: Column(children: [
          _createTabBar(context),
          Expanded(
            child: TabBarView(
              key: const Key('tab_bar_view'),
              controller: _tabController,
              children: _makeTabsContent(),
            ),
          ),
        ]),
      ),
    );
  }

  Border _getTabBorder(AppStyle appStyle, GlobalKey<FormBuilderState> tabLabel) {
    if (tabLabel == _tabsDataList.first) {
      return Border(top: appStyle.borderTabSide, right: appStyle.borderTabSide, left: appStyle.borderTabSide);
    } else {
      return Border(top: appStyle.borderTabSide, right: appStyle.borderTabSide);
    }
  }

  @override
  Map<int, VoidCallback> provideKeyboardActions() {
    final fromSuper = super.provideKeyboardActions();
    final ctrlPrefix = LogicalKeyboardKey.control.keyId;

    fromSuper[ctrlPrefix + LogicalKeyboardKey.pageUp.keyId] = () => _jumpToNextActiveTab(true);
    fromSuper[ctrlPrefix + LogicalKeyboardKey.pageDown.keyId] = () => _jumpToNextActiveTab(false);
    fromSuper[ctrlPrefix + LogicalKeyboardKey.arrowUp.keyId] = () => _jumpToNextActiveTab(true);
    fromSuper[ctrlPrefix + LogicalKeyboardKey.arrowDown.keyId] = () => _jumpToNextActiveTab(false);

    return fromSuper;
  }

  void _jumpToNextActiveTab(bool forward) {
    int index = _tabController!.index;
    int tabsLength = _tabController!.length;

    for (int i = 0; i < tabsLength; i++) {
      if (!forward) {
        index = index == tabsLength - 1 ? 0 : index + 1;
      } else {
        index = index == 0 ? tabsLength - 1 : index - 1;
      }

      GlobalKey<FormBuilderState> globalKey = _tabsDataList[index];
      if (!formManager.isTabDisabled(globalKey)) {
        _tabController!.index = index;
        _switchTab();
        break;
      }
    }
  }

  void _switchTab({bool isDisabled = false}) {
    if (isDisabled) {
      _tabController?.index = _tabController!.previousIndex;
    } else {
      setState(() => _currentTabIndex = _tabController!.index);
    }
  }
}
