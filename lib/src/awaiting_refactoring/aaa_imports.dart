import 'package:flutter_form_bricks/src/form_fields/components/base/form_field_brick.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_manager.dart';
import 'package:flutter_form_bricks/src/forms/form_manager/form_status.dart';

import 'package:flutter_form_bricks/src/ui_params/ui_params.dart';
import 'package:flutter_form_bricks/src/ui_params/app_color/app_color.dart';
import 'package:flutter_form_bricks/src/ui_params/app_color/app_color.dart';
import 'package:flutter_form_bricks/src/ui_params/app_style/app_style.dart';
import 'package:flutter_form_bricks/src/form_fields/components/labelled_box/label_position.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/states_color_maker.dart';

import 'package:flutter_form_bricks/src/string_literals/gen/bricks_localizations.dart';

import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/date_time/date_time_inputs.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/single_form/single_form.dart';

import 'package:flutter_form_bricks/src/form_fields/components/base/form_field_descriptor.dart';
import 'package:flutter_form_bricks/src/form_fields/components/base/validate_mode_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/form_field_data.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/time_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_time_utils.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/extension_date_time.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/format_and_validate/date_formatter_validator.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/current_date.dart';
import 'package:flutter_form_bricks/src/form_fields/text/date_time/components/date_time_limits.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/text_field_brick.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/icon_button_config.dart';
import 'package:flutter_form_bricks/src/form_fields/text/base/decoration_config.dart';

import 'package:flutter_form_bricks/src/form_fields/text/base/outer_label_config.dart';
import 'package:flutter_form_bricks/src/forms/base/form_brick.dart';
import 'package:flutter_form_bricks/src/forms/base/form_schema.dart';
import 'package:flutter_form_bricks/src/forms/state/form_data.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/forms/base/form_utils.dart';

import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/inputs/input_validator_provider.dart';
import 'package:flutter_form_bricks/src/utils/utils.dart';
import 'package:flutter_form_bricks/src/utils/input_decoration_extension.dart';
// =========
