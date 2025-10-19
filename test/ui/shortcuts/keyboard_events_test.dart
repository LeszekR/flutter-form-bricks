// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shipping_ui/ui/shortcuts/keyboard_shortcuts.dart';
//
// void main() {
//
//   const mockKeyEvent = RawKeyDownEvent(data: RawKeyEventDataAndroid(keyCode: 65), character: 'a');
//
//   tearDown(() {
//     KeyboardEvents.instance().unSubscribeAll();
//   });
//
//   test('Should add listener and get called on event', () {
//     // given
//     final KeyboardEvents keyboardEvents = KeyboardEvents.instance();
//
//     int timesCalled = 0;
//     testListener(final RawKeyEvent event) {
//       timesCalled++;
//     }
//
//     // when
//     keyboardEvents.subscribe(testListener);
//     keyboardEvents.handleKey(mockKeyEvent);
//
//     // then
//     expect(timesCalled, 1);
//   });
//
//   test('Should react only to last listener in queue', () {
//     // given
//     final KeyboardEvents keyboardEvents = KeyboardEvents.instance();
//
//     int firstCalled = 0;
//     firstListener(final RawKeyEvent event) {
//       firstCalled++;
//     }
//
//     int secondCalled = 0;
//     secondListener(final RawKeyEvent event) {
//       secondCalled++;
//     }
//
//     keyboardEvents.subscribe(firstListener);
//     keyboardEvents.subscribe(secondListener);
//
//     // when
//     keyboardEvents.handleKey(mockKeyEvent);
//
//     // the
//     expect(firstCalled, 0);
//     expect(secondCalled, 1);
//   });
//
//   test('Should not react to listener after got unsubscribed', () {
//     // given
//     final KeyboardEvents keyboardEvents = KeyboardEvents.instance();
//
//     int firstCalled = 0;
//     firstListener(final RawKeyEvent event) {
//       firstCalled++;
//     }
//
//
//     int secondCalled = 0;
//     secondListener(final RawKeyEvent event) {
//       secondCalled++;
//     }
//
//     keyboardEvents.subscribe(firstListener);
//     keyboardEvents.subscribe(secondListener);
//
//     keyboardEvents.unSubscribe(secondListener);
//
//     // when
//     keyboardEvents.handleKey(mockKeyEvent);
//
//     // the
//     expect(firstCalled, 1);
//     expect(secondCalled, 0);
//   });
//
//   test('Should call menu listener if no other is registered', () {
//     // given
//     final KeyboardEvents keyboardEvents = KeyboardEvents.instance();
//
//     int menuCalled = 0;
//     menuListener(final RawKeyEvent event) {
//       menuCalled++;
//     }
//     keyboardEvents.subscribeMenu(menuListener);
//
//     int firstCalled = 0;
//     firstListener(final RawKeyEvent event) {
//       firstCalled++;
//     }
//
//     int secondCalled = 0;
//     secondListener(final RawKeyEvent event) {
//       secondCalled++;
//     }
//
//     keyboardEvents.subscribe(firstListener);
//     keyboardEvents.subscribe(secondListener);
//
//     keyboardEvents.unSubscribe(secondListener);
//     keyboardEvents.unSubscribe(firstListener);
//
//     // when
//     keyboardEvents.handleKey(mockKeyEvent);
//
//     // the
//     expect(firstCalled, 0);
//     expect(secondCalled, 0);
//     expect(menuCalled, 1);
//   });
// }