import 'package:flutter/cupertino.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/tabbed_form/tab_status.dart';
import 'package:flutter_form_bricks/src/forms/base/form_brick.dart';

class TabData {
  final GlobalKey<FormStateBrick> globalKey;
  final String label;
  final Widget Function() makeTabContent;
  final TabStatus initialStatus;
  TabStatus currentStatus = TabStatus.tabOk;

  bool isValid() => currentStatus != TabStatus.tabOk;

  TabData({
    required this.globalKey,
    required this.label,
    required this.makeTabContent,
    required this.initialStatus,
  });
}
