import 'package:flutter/cupertino.dart';

class StateAwareContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget Function(BuildContext context, WidgetStatesController statesObserver, WidgetStatesController statesNotifier) childBuilder;

  const StateAwareContainer(this.width, this.height, this.statesObserver, this.statesNotifier, this.childBuilder);

  @override
  Widget build(BuildContext context) {
      final WidgetStatesController statesObserver;
      final WidgetStatesController statesNotifier;
      return Container(
        width: width,
        height: height,
        child: ValueListenableBuilder(
          valueListenable: statesNotifier,
          builder: childBuilder,
        )
      )
  }
}
