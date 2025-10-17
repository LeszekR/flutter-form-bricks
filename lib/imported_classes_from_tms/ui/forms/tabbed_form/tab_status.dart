import 'dart:ui';
import '../../style/app_color.dart';
import '../../style/app_style.dart';

enum ETabStatus { tabDisabled, tabError, tabOk }

extension TabStatusExtension on ETabStatus {
  Color get backgroundColor {
    switch (this) {
      case ETabStatus.tabDisabled:
        return AppColor.tabDisabled;
      case ETabStatus.tabError:
        return AppColor.tabError;
      default:
        return AppColor.tabEnabled;
    }
  }

  Color get fontColor {
    switch (this) {
      case ETabStatus.tabDisabled:
        return AppColor.tabFontDisabled;
      case ETabStatus.tabError:
        return AppColor.tabFontError;
      default:
        return AppColor.tabFontEnabled;
    }
  }

  FontStyle get fontStyle {
    switch (this) {
      case ETabStatus.tabDisabled:
        return AppStyle.tabFontDisabled;
      case ETabStatus.tabError:
        return AppStyle.tabFontError;
      default:
        return AppStyle.tabFontEnabled;
    }
  }
}
