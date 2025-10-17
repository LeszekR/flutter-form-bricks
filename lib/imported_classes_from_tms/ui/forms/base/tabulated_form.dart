import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shipping_ui/ui/style/app_style.dart';
import '../../style/app_size.dart';
import '../form_manager/tabulated_form_manager.dart';
import '../tabbed_form/tab_data.dart';
import '../tabbed_form/tab_status.dart';
import 'entity_form.dart';
import 'form_utils.dart';

abstract class TabulatedForm extends EntityForm {
  TabulatedForm({super.key}) : super(formManager: TabulatedFormManager());
}

abstract class TabulatedFormState<T extends TabulatedForm> extends EntityFormState<T>
    with SingleTickerProviderStateMixin {
  @override
  TabulatedFormManager get formManager => super.formManager as TabulatedFormManager;

  List<TabData> makeTabsData();

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

  void _setInitialTabIndex() {
    for (int i = 0; i < _tabsDataList.length; i++) {
      if (_tabsDataList[i].initialStatus != ETabStatus.tabDisabled) {
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

  //initial tab state has to be called here so the form is aware of all children inputs and able to tell us if any validation failed
  @override
  void postConstruct() {
    super.postConstruct();
    setState(() => formManager.calculateAllTabsStatuses());
  }

  @override
  Widget build(final BuildContext context) {
    return FormUtils.defaultScaffold(
      label: provideLabel(),
      child: Column(
        children: [
          _createFormBody(context),
          AppSize.spacerBoxVerticalSmall,
          createFormControlPanel(context),
        ],
      ),
    );
  }

  TabBar _createTabBar() {
    final List<Tab> tabs = [];

    for (TabData tabData in _tabsDataList) {
      var globalKeyString = tabData.globalKey.toString();
      tabs.add(Tab(
        height: AppSize.tabHeight,
        icon: ValueListenableBuilder<Map<String, ETabStatus>>(
            valueListenable: formManager.tabStatusNotifier,
            builder: (BuildContext context, Map<String, ETabStatus> observableMap, Widget? child) {
              final ETabStatus tabStatus = observableMap[globalKeyString] ?? ETabStatus.tabOk;
              return Container(
                key: Key(globalKeyString),
                decoration: BoxDecoration(color: tabStatus.backgroundColor, border: _getTabBorder(tabData.globalKey)),
                constraints: BoxConstraints(
                  minWidth: AppSize.tabMinWidth,
                  minHeight: AppSize.tabHeight,
                  maxHeight: AppSize.tabHeight,
                ),
                padding: EdgeInsets.only(left: AppSize.paddingTabsVertical, right: AppSize.paddingTabsVertical),
                child: Center(
                  child: Text(
                    tabData.label,
                    style: TextStyle(color: tabStatus.fontColor, fontStyle: tabStatus.fontStyle),
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

  Widget _createFormBody(final BuildContext context) {
    return DefaultTabController(
      length: _tabsDataList.length,
      child: Expanded(
        child: Column(children: [
          _createTabBar(),
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

  Border _getTabBorder(GlobalKey<FormBuilderState> tabLabel) {
    if (tabLabel == _tabsDataList.first) {
      return Border(top: AppStyle.borderTabSide, right: AppStyle.borderTabSide, left: AppStyle.borderTabSide);
    } else {
      return Border(top: AppStyle.borderTabSide, right: AppStyle.borderTabSide);
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

  void _jumpToNextActiveTab(final bool forward) {
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
