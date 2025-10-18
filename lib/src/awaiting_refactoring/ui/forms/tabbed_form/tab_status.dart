import 'dart:ui';

import 'package:flutter_form_bricks/src/ui_params/app_color/app_color.dart';
import 'package:flutter_form_bricks/src/ui_params/app_style/app_style.dart';

enum TabStatus { tabDisabled, tabError, tabOk }

extension TabStatusExtension on TabStatus {
  Color backgroundColor(AppColor appColor) {
    switch (this) {
      case TabStatus.tabDisabled:
        return appColor.tabDisabled;
      case TabStatus.tabError:
        return appColor.tabError;
      default:
        return appColor.tabEnabled;
    }
  }

  Color fontColor(AppColor appColor) {
    switch (this) {
      case TabStatus.tabDisabled:
        return appColor.tabFontDisabled;
      case TabStatus.tabError:
        return appColor.tabFontError;
      default:
        return appColor.tabFontEnabled;
    }
  }

  FontStyle fontStyle(AppStyle appStyle) {
    switch (this) {
      case TabStatus.tabDisabled:
        return appStyle.tabFontDisabled;
      case TabStatus.tabError:
        return appStyle.tabFontError;
      default:
        return appStyle.tabFontEnabled;
    }
  }
}
