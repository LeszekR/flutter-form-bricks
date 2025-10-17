import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shipping_ui/ui/forms/tabbed_form/tab_status.dart';

class TabData {
  final GlobalKey<FormBuilderState> globalKey;
  final String label;
  final Widget Function() makeTabContent;
  final ETabStatus initialStatus;
  ETabStatus currentStatus = ETabStatus.tabOk;

  bool isValid() => currentStatus != ETabStatus.tabOk;

  TabData({
    required this.globalKey,
    required this.label,
    required this.makeTabContent,
    required this.initialStatus,
  });
}
