import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_color/app_color.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/app_size.dart';
import 'package:flutter_form_bricks/src/ui_params/app_style/app_style.dart';

import '../ui_params/ui_params.dart';

AppStyle getAppStyle(BuildContext context) => UiParams.of(context).appStyle;

AppSize getAppSize(BuildContext context) => UiParams.of(context).appSize;

AppColor getAppColor(BuildContext context) => UiParams.of(context).appColor;
