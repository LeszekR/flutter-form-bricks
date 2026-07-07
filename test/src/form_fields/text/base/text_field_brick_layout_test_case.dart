import 'package:flutter/material.dart';
import 'package:flutter_form_bricks/src/ui_params/app_size/text_field_height_resolver/widget_height_probe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/form_fields/components/state/field_content.dart';
import 'package:flutter_form_bricks/src/forms/base/form_ui_update_coordinator.dart';
import 'package:flutter_form_bricks/src/forms/base/form_ui_update_scope.dart';

/// Builds the brick under test from the already-created test [FormManager].
///
/// Typical use in a concrete case:
///
/// ```dart
/// brickBuilder: (formManager) => PlainTextField(
///   keyString: 'field',
///   formManager: formManager,
///   validateMode: ValidateModeBrick.noValidator,
///   inputDecoration: const InputDecoration(...),
///   outerLabelConfig: ...,
///   buttonConfig: ...,
/// )
/// ```
typedef TextFieldBrickUnderTestBuilder = Widget Function(FormManager formManager);

/// A reusable parameterized case for TextFieldBrick layout tests.
///
/// This class intentionally contains no concrete case data. Add cases in your
/// test file by filling [textFieldBrickLayoutCases].
final class TextFieldBrickLayoutTestCase {
  final String name;

  /// Stable keyString used by the brick and fake FormManager/FormSchema.
  final String keyString;

  /// Initial raw input stored in FormData before the brick is built.
  final TextEditingValue? initialInput;

  /// Initial error stored in FormData before the brick is built.
  ///
  /// Use this for the "has errorText" and "has error widget" cases. The brick
  /// will read this value in FormFieldStateBrick.initState().
  final String? initialErrorText;

  /// The actual TextFieldBrick configuration for this case.
  final TextFieldBrickUnderTestBuilder brickBuilder;

  /// The widget size passed to tester.binding.setSurfaceSize.
  final Size surfaceSize;

  /// Wraps the field in any extra constraints/scaffolding needed by a case.
  final Widget Function(Widget child)? fieldWrapper;

  /// Finder for the editable area. Default is [EditableText], which is the
  /// closest stable thing to the actual Flutter editing area.
  final Finder editingAreaFinder;

  /// Optional finder for the whole TextField widget. Useful for checking the
  /// InputDecoration/border configuration.
  final Finder textFieldFinder;

  /// Optional finder for the button widget.
  final Finder? buttonFinder;

  /// Optional finder for the outer label widget/text.
  final Finder? outerLabelFinder;

  /// Optional finders for bottom-area widgets/text.
  final Finder? errorFinder;
  final Finder? helperFinder;
  final Finder? counterFinder;

  /// Expected relative geometry and dimensions.
  final TextFieldBrickLayoutExpectations expected;

  const TextFieldBrickLayoutTestCase({
    required this.name,
    required this.brickBuilder,
    required this.expected,
    this.keyString = 'field',
    this.initialInput,
    this.initialErrorText,
    this.surfaceSize = const Size(1200, 800),
    this.fieldWrapper,
    // TU PRZERWAŁEM - read, understand, use the test - do all tests on page 1 of Bricks_tests.doc
    this.editingAreaFinder = const _ByTypeFinder<EditableText>(),
    this.textFieldFinder = const _ByTypeFinder<TextField>(),
    this.buttonFinder,
    this.outerLabelFinder,
    this.errorFinder,
    this.helperFinder,
    this.counterFinder,
  });
}

/// All optional layout expectations for one parameterized case.
///
/// Leave a value null when the case does not assert that feature.
final class TextFieldBrickLayoutExpectations {
  /// How many WidgetHeightProbe widgets should be inserted on the measuring
  /// frame. This is the practical test for "number of height calculations".
  ///
  /// Expected values usually are:
  /// - 0 when no measuring is needed,
  /// - 1 for editing area only,
  /// - 2 editing area + one bottom widget,
  /// - 3 editing area + two bottom widgets,
  /// - 4 editing area + error/helper/counter.
  final int? measuringProbeCount;

  /// If true, after the settle frame there must be no WidgetHeightProbe left.
  final bool expectNoProbesAfterSettled;

  final RectExpectation? buttonRect;
  final RectExpectation? outerLabelRect;
  final RectExpectation? errorRect;
  final RectExpectation? helperRect;
  final RectExpectation? counterRect;

  /// Expected size of the editable area [EditableText] render box.
  final SizeExpectation? editingAreaSize;

  /// Expected size of the button render box.
  final SizeExpectation? buttonSize;

  /// Expected size of the outer label render box.
  final SizeExpectation? outerLabelSize;

  /// Checks button height == editing area height.
  final bool buttonHeightEqualsEditingAreaHeight;

  /// Checks side-label height == editing area height.
  final bool outerLabelHeightEqualsEditingAreaHeight;

  /// Checks the distance between the editing area and the button.
  final GapExpectation? editingAreaToButtonGap;

  /// Checks the TextField InputDecoration border type and/or border side.
  final InputBorderExpectation? textFieldBorder;

  /// Checks the IconButton effective style type and/or border side.
  final ButtonBorderExpectation? buttonBorder;

  const TextFieldBrickLayoutExpectations({
    this.measuringProbeCount,
    this.expectNoProbesAfterSettled = true,
    this.buttonRect,
    this.outerLabelRect,
    this.errorRect,
    this.helperRect,
    this.counterRect,
    this.editingAreaSize,
    this.buttonSize,
    this.outerLabelSize,
    this.buttonHeightEqualsEditingAreaHeight = false,
    this.outerLabelHeightEqualsEditingAreaHeight = false,
    this.editingAreaToButtonGap,
    this.textFieldBorder,
    this.buttonBorder,
  });
}

final class RectExpectation {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;

  /// Optional relation to the editing area's rect.
  final RelativeRectExpectation? relativeToEditingArea;

  final double tolerance;

  const RectExpectation({
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    this.relativeToEditingArea,
    this.tolerance = 0.001,
  });
}

final class RelativeRectExpectation {
  final double? leftDelta;
  final double? topDelta;
  final double? rightDelta;
  final double? bottomDelta;
  final double? centerYDelta;
  final double? centerXDelta;

  const RelativeRectExpectation({
    this.leftDelta,
    this.topDelta,
    this.rightDelta,
    this.bottomDelta,
    this.centerYDelta,
    this.centerXDelta,
  });
}

final class SizeExpectation {
  final double? width;
  final double? height;
  final double tolerance;

  const SizeExpectation({this.width, this.height, this.tolerance = 0.001});
}

final class GapExpectation {
  final Finder from;
  final Finder to;

  /// Expected horizontal gap: to.left - from.right.
  final double? horizontal;

  /// Expected vertical gap: to.top - from.bottom.
  final double? vertical;

  final double tolerance;

  const GapExpectation({
    required this.from,
    required this.to,
    this.horizontal,
    this.vertical,
    this.tolerance = 0.001,
  });
}

final class InputBorderExpectation {
  final Type? borderRuntimeType;
  final BorderSide? side;

  const InputBorderExpectation({this.borderRuntimeType, this.side});
}

final class ButtonBorderExpectation {
  final Type? shapeRuntimeType;
  final BorderSide? side;

  const ButtonBorderExpectation({this.shapeRuntimeType, this.side});
}

/// Finder usable as a const default value in [TextFieldBrickLayoutTestCase].
final class _ByTypeFinder<T extends Widget> extends MatchFinder {
  _ByTypeFinder({super.skipOffstage});

  @override
  String get description => 'widget with runtimeType $T';

  @override
  bool matches(Element candidate) => candidate.widget is T;
}

Future<void> pumpTextFieldBrickLayoutCase(
    WidgetTester tester,
    TextFieldBrickLayoutTestCase c,
    ) async {
  tester.view.physicalSize = c.surfaceSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final formManager = _TextFieldBrickLayoutTestFormManager(
    keyString: c.keyString,
    initialInput: c.initialInput,
    initialErrorText: c.initialErrorText,
  );

  Widget field = c.brickBuilder(formManager);
  field = c.fieldWrapper?.call(field) ?? field;

  await tester.pumpWidget(
    UiParams(
      data: UiParamsData(),
      child: MaterialApp(
        localizationsDelegates: BricksLocalizations.localizationsDelegates,
        supportedLocales: BricksLocalizations.supportedLocales,
        home: FormUiUpdateScope(
          coordinator: FormUiUpdateCoordinator(),
          child: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: field,
            ),
          ),
        ),
      ),
    ),
  );
}

Rect widgetRect(WidgetTester tester, Finder finder) {
  expect(finder, findsOneWidget);
  final topLeft = tester.getTopLeft(finder);
  final size = tester.getSize(finder);
  return topLeft & size;
}

void expectRect(
    WidgetTester tester,
    Finder finder,
    RectExpectation expectation, {
      required Rect editingAreaRect,
    }) {
  final rect = widgetRect(tester, finder);
  final t = expectation.tolerance;

  void close(num? actual, num? expected, String name) {
    if (expected == null) return;
    expect(actual, closeTo(expected, t), reason: '$finder.$name');
  }

  close(rect.left, expectation.left, 'left');
  close(rect.top, expectation.top, 'top');
  close(rect.right, expectation.right, 'right');
  close(rect.bottom, expectation.bottom, 'bottom');
  close(rect.width, expectation.width, 'width');
  close(rect.height, expectation.height, 'height');

  final rel = expectation.relativeToEditingArea;
  if (rel != null) {
    close(rect.left - editingAreaRect.left, rel.leftDelta, 'leftDelta');
    close(rect.top - editingAreaRect.top, rel.topDelta, 'topDelta');
    close(rect.right - editingAreaRect.right, rel.rightDelta, 'rightDelta');
    close(rect.bottom - editingAreaRect.bottom, rel.bottomDelta, 'bottomDelta');
    close(rect.center.dy - editingAreaRect.center.dy, rel.centerYDelta, 'centerYDelta');
    close(rect.center.dx - editingAreaRect.center.dx, rel.centerXDelta, 'centerXDelta');
  }
}

void expectSize(WidgetTester tester, Finder finder, SizeExpectation expectation) {
  final size = tester.getSize(finder);
  if (expectation.width != null) {
    expect(size.width, closeTo(expectation.width!, expectation.tolerance), reason: '$finder.width');
  }
  if (expectation.height != null) {
    expect(size.height, closeTo(expectation.height!, expectation.tolerance), reason: '$finder.height');
  }
}

void expectGap(WidgetTester tester, GapExpectation expectation) {
  final from = widgetRect(tester, expectation.from);
  final to = widgetRect(tester, expectation.to);
  if (expectation.horizontal != null) {
    expect(to.left - from.right, closeTo(expectation.horizontal!, expectation.tolerance));
  }
  if (expectation.vertical != null) {
    expect(to.top - from.bottom, closeTo(expectation.vertical!, expectation.tolerance));
  }
}

void expectTextFieldBorder(
    WidgetTester tester,
    Finder textFieldFinder,
    InputBorderExpectation expectation,
    ) {
  final textField = tester.widget<TextField>(textFieldFinder);
  final border = textField.decoration?.border;
  if (expectation.borderRuntimeType != null) {
    expect(border.runtimeType, expectation.borderRuntimeType);
  }
  if (expectation.side != null) {
    expect(border, isA<OutlineInputBorder>());
    final outline = border! as OutlineInputBorder;
    expect(outline.borderSide, expectation.side);
  }
}

void expectButtonBorder(
    WidgetTester tester,
    Finder buttonFinder,
    ButtonBorderExpectation expectation,
    ) {
  final iconButton = tester.widget<IconButton>(find.descendant(
    of: buttonFinder,
    matching: find.byType(IconButton),
  ));
  final states = <WidgetState>{};
  final shape = iconButton.style?.shape?.resolve(states);
  final side = iconButton.style?.side?.resolve(states);

  if (expectation.shapeRuntimeType != null) {
    expect(shape.runtimeType, expectation.shapeRuntimeType);
  }
  if (expectation.side != null) {
    expect(side, expectation.side);
  }
}

void runTextFieldBrickLayoutCase(TextFieldBrickLayoutTestCase c) {
  testWidgets(c.name, (tester) async {
    await pumpTextFieldBrickLayoutCase(tester, c);

    if (c.expected.measuringProbeCount != null) {
      expect(
        find.byType(WidgetHeightProbe),
        findsNWidgets(c.expected.measuringProbeCount!),
        reason: 'WidgetHeightProbe count on the measuring frame',
      );
    }

    // Complete measurement frame and rebuild from cached heights.
    await tester.pump();
    await tester.pump();

    if (c.expected.expectNoProbesAfterSettled) {
      expect(find.byType(WidgetHeightProbe), findsNothing);
    }

    final editingAreaRect = widgetRect(tester, c.editingAreaFinder);

    if (c.expected.editingAreaSize != null) {
      expectSize(tester, c.editingAreaFinder, c.expected.editingAreaSize!);
    }

    if (c.buttonFinder != null) {
      expect(c.buttonFinder!, findsOneWidget);
      if (c.expected.buttonSize != null) {
        expectSize(tester, c.buttonFinder!, c.expected.buttonSize!);
      }
      if (c.expected.buttonRect != null) {
        expectRect(tester, c.buttonFinder!, c.expected.buttonRect!, editingAreaRect: editingAreaRect);
      }
      if (c.expected.buttonHeightEqualsEditingAreaHeight) {
        expect(
          tester.getSize(c.buttonFinder!).height,
          closeTo(editingAreaRect.height, 0.001),
        );
      }
      if (c.expected.buttonBorder != null) {
        expectButtonBorder(tester, c.buttonFinder!, c.expected.buttonBorder!);
      }
    } else {
      expect(c.expected.buttonRect, isNull, reason: 'buttonRect requires buttonFinder');
      expect(c.expected.buttonSize, isNull, reason: 'buttonSize requires buttonFinder');
    }

    if (c.outerLabelFinder != null) {
      expect(c.outerLabelFinder!, findsOneWidget);
      if (c.expected.outerLabelSize != null) {
        expectSize(tester, c.outerLabelFinder!, c.expected.outerLabelSize!);
      }
      if (c.expected.outerLabelRect != null) {
        expectRect(tester, c.outerLabelFinder!, c.expected.outerLabelRect!, editingAreaRect: editingAreaRect);
      }
      if (c.expected.outerLabelHeightEqualsEditingAreaHeight) {
        expect(
          tester.getSize(c.outerLabelFinder!).height,
          closeTo(editingAreaRect.height, 0.001),
        );
      }
    }

    if (c.errorFinder != null && c.expected.errorRect != null) {
      expectRect(tester, c.errorFinder!, c.expected.errorRect!, editingAreaRect: editingAreaRect);
    }
    if (c.helperFinder != null && c.expected.helperRect != null) {
      expectRect(tester, c.helperFinder!, c.expected.helperRect!, editingAreaRect: editingAreaRect);
    }
    if (c.counterFinder != null && c.expected.counterRect != null) {
      expectRect(tester, c.counterFinder!, c.expected.counterRect!, editingAreaRect: editingAreaRect);
    }

    if (c.expected.editingAreaToButtonGap != null) {
      expectGap(tester, c.expected.editingAreaToButtonGap!);
    }

    if (c.expected.textFieldBorder != null) {
      expectTextFieldBorder(tester, c.textFieldFinder, c.expected.textFieldBorder!);
    }
  });
}

final class _TextFieldBrickLayoutTestFormData extends FormData {
  _TextFieldBrickLayoutTestFormData({super.initiallyFocusedKeyString});
}

final class _TextFieldBrickLayoutTestFormSchema extends FormSchema {
  _TextFieldBrickLayoutTestFormSchema({
    required String keyString,
    TextEditingValue? initialInput,
  }) : super(
    formKey: GlobalKey<FormStateBrick>(),
    initiallyFocusedKeyString: keyString,
    fieldDescriptors: [
      PlainTextFieldDescriptor(
        keyString: keyString,
        initialInput: initialInput,
      ),
    ],
  );
}

final class _TextFieldBrickLayoutTestFormManager extends FormManager {
  _TextFieldBrickLayoutTestFormManager({
    required String keyString,
    TextEditingValue? initialInput,
    String? initialErrorText,
  }) : super(
    formData: _TextFieldBrickLayoutTestFormData(initiallyFocusedKeyString: keyString),
    formSchema: _TextFieldBrickLayoutTestFormSchema(
      keyString: keyString,
      initialInput: initialInput,
    ),
  ) {
    if (initialErrorText != null) {
      fieldDataMap[keyString] = fieldDataMap[keyString]!.copyWith(
        fieldContent: FieldContent<TextEditingValue, String>.err(initialInput, initialErrorText),
      );
    }
  }

  @override
  FormStatus checkStatus() => FormStatus.valid;

  @override
  Map<String, dynamic> collectInputs() => {
    for (final entry in fieldDataMap.entries) entry.key: entry.value.fieldContent.input,
  };
}
