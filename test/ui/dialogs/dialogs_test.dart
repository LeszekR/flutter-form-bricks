import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bricks/shelf.dart';
import 'package:flutter_form_bricks/src/awaiting_refactoring/ui/shortcuts/keyboard_shortcuts.dart';
import 'package:flutter_form_bricks/src/dialogs/progress_info.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_data.dart';

void main() {
  final Map<int, String> keyCodeMapping = {66: "Enter", 111: "Escape"};

  tearDown(() => KeyboardEvents().unSubscribeAll());

  testWidgets('showLoadingDialog should display spinner with text and dismiss on future completion',
      (WidgetTester tester) async {
    // given
    const text = 'Proszę czekać';
    final Future<void> mockFuture = Future.delayed(const Duration(milliseconds: 100));

    await tester.pumpWidget(TestWidget(
        triggerDialog: () =>
            ProgressInfo.showLoadingDialog<void>(tester.element(find.byType(ElevatedButton)), mockFuture)));

    // when
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // then
    expect(find.text(text), findsOneWidget);
    await tester.pumpAndSettle(const Duration(milliseconds: 110));
    expect(find.text(text), findsNothing);
  });

  group('confirmation dialog should return proper value and handle key event subscription', () {
    final List<TestData> testParameters = [
      TestData("OK", true),
      TestData("Anuluj", false),
    ];

    for (final param in testParameters) {
      testWidgets('confirmation dialog should return "${param.expected}" when "${param.input}" is pressed',
          (WidgetTester tester) async {
        // given
        final initialListeners = KeyboardEvents().countListeners();
        int timesCalled = 0;

        await tester.pumpWidget(TestWidget(
          triggerDialog: () =>
              Dialogs.decisionDialogOkCancel(tester.element(find.byType(ElevatedButton)), 'Title', 'Body')
                  .then((value) {
            expect(value, param.expected);
            timesCalled = timesCalled + 1;
          }),
        ));

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(KeyboardEvents().countListeners(), initialListeners + 1);

        // when
        await tester.tap(find.text(param.input));
        await tester.pumpAndSettle();

        // then
        expect(timesCalled, 1);
        expect(KeyboardEvents().countListeners(), initialListeners);
      });
    }
  });

  group('confirmation dialog should handle key events correctly', () {
    final List<TestData> testParameters = [
      TestData(66, true), // KeyCode for Enter
      TestData(111, false), // KeyCode for Escape
    ];

    for (final param in testParameters) {
      testWidgets(
          'confirmation dialog should return "${param.expected}" when key with KeyCode ${keyCodeMapping[param.input]} is pressed',
          (WidgetTester tester) async {
        // given
        final initialListeners = KeyboardEvents().countListeners();
        int timesCalled = 0;

        await tester.pumpWidget(TestWidget(
          triggerDialog: () =>
              Dialogs.decisionDialogOkCancel(tester.element(find.byType(ElevatedButton)), 'Title', 'Body')
                  .then((value) {
            expect(value, param.expected);
            timesCalled += 1;
          }),
        ));

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(KeyboardEvents().countListeners(), initialListeners + 1);

        // when
        final keyCode = param.input;
        final keyEvent = RawKeyDownEvent(data: RawKeyEventDataAndroid(keyCode: keyCode, flags: 0));
        KeyboardEvents().handleKey(keyEvent);
        await tester.pumpAndSettle();

        // then
        expect(timesCalled, 1);
        expect(KeyboardEvents().countListeners(), initialListeners);
      });
    }
  });

  group('action dialog should trigger action based on user interaction and handle key event subscription', () {
    final List<TestData> testParameters = [
      TestData("OK", 1),
      TestData("Anuluj", 0),
    ];

    for (final param in testParameters) {
      final message = param.expected == 1 ? "" : "NOT";
      testWidgets('action dialog should $message trigger action when "${param.input}" is pressed',
          (WidgetTester tester) async {
        // given
        final initialListeners = KeyboardEvents().countListeners();
        int timesCalled = 0;

        action() => timesCalled = timesCalled + 1;

        await tester.pumpWidget(TestWidget(
            triggerDialog: () => Dialogs.decisionDialogOkCancel(
                tester.element(find.byType(ElevatedButton)), 'Title', 'Body',
                action: action)));

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(KeyboardEvents().countListeners(), initialListeners + 1);

        // when
        await tester.tap(find.text(param.input));
        await tester.pumpAndSettle();

        // then
        expect(timesCalled, param.expected);
        expect(KeyboardEvents().countListeners(), initialListeners);
      });
    }
  });

  group('action dialog should trigger action based on keyboard interaction and handle key event subscription', () {
    final List<TestData> testParameters = [
      TestData(66, 1), // KeyCode for Enter
      TestData(111, 0), // KeyCode for Escape
    ];

    for (final param in testParameters) {
      final message = param.expected == 1 ? "" : "NOT";
      testWidgets('action dialog should $message trigger action when "${keyCodeMapping[param.input]}" is pressed',
          (WidgetTester tester) async {
        // given
        final initialListeners = KeyboardEvents().countListeners();
        int timesCalled = 0;

        action() => timesCalled = timesCalled + 1;

        await tester.pumpWidget(TestWidget(
            triggerDialog: () => Dialogs.decisionDialogOkCancel(
                tester.element(find.byType(ElevatedButton)), 'Title', 'Body',
                action: action)));

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(KeyboardEvents().countListeners(), initialListeners + 1);

        // when
        final keyCode = param.input;
        final keyEvent = RawKeyDownEvent(data: RawKeyEventDataAndroid(keyCode: keyCode, flags: 0));
        KeyboardEvents().handleKey(keyEvent);
        await tester.pumpAndSettle();

        // then
        expect(timesCalled, param.expected);
        expect(KeyboardEvents().countListeners(), initialListeners);
      });
    }
  });

  testWidgets('information dialog should close when OK is pressed', (WidgetTester tester) async {
    // given
    final initialListeners = KeyboardEvents().countListeners();

    await tester.pumpWidget(TestWidget(
        triggerDialog: () => Dialogs.informationDialog(tester.element(find.byType(ElevatedButton)), 'Title', 'Body')));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(KeyboardEvents().countListeners(), initialListeners + 1);

    // when
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();

    // then
    expect(KeyboardEvents().countListeners(), initialListeners);
    expect(find.text("OK"), findsNothing);
  });

  group('information dialog should handle key events correctly', () {
    final List<TestData> testParameters = [
      TestData(66, true), // KeyCode for Enter
      TestData(111, true), // KeyCode for Escape
    ];

    for (final param in testParameters) {
      testWidgets('information dialog should close when key with KeyCode ${keyCodeMapping[param.input]} is pressed',
          (WidgetTester tester) async {
        // given
        final initialListeners = KeyboardEvents().countListeners();

        await tester.pumpWidget(TestWidget(
            triggerDialog: () =>
                Dialogs.informationDialog(tester.element(find.byType(ElevatedButton)), 'Title', 'Body')));

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(KeyboardEvents().countListeners(), initialListeners + 1);

        // when
        final keyCode = param.input;
        final keyEvent = RawKeyDownEvent(data: RawKeyEventDataAndroid(keyCode: keyCode, flags: 0));
        KeyboardEvents().handleKey(keyEvent);
        await tester.pumpAndSettle();

        // then
        expect(KeyboardEvents().countListeners(), initialListeners);
        expect(find.text("R.buttonCancelText"), findsNothing);
      });
    }
  });
}

class TestWidget extends StatelessWidget {
  final Future<void> Function() triggerDialog;

  const TestWidget({super.key, required this.triggerDialog});

  @override
  Widget build(BuildContext context) {
    var uiParamsData = UiParamsData();
    return UiParams(
        data: uiParamsData,
        child: MaterialApp(
            locale: const Locale("pl"),
            localizationsDelegates: BricksLocalizations.localizationsDelegates,
            supportedLocales: BricksLocalizations.supportedLocales,
            home: Builder(builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => triggerDialog(),
                  child: const Text('Show Dialog'),
                ),
              );
            })));
  }
}
