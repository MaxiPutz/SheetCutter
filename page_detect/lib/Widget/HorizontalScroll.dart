import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScrollViewHorizontal extends StatefulWidget {
  List<Widget> widgetList;
  ScrollViewHorizontal(this.widgetList, {super.key});

  @override
  State<ScrollViewHorizontal> createState() => _ScrollViewState();
}

class _ScrollViewState extends State<ScrollViewHorizontal> {
  ScrollController _horizontalController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          print(event.scrollDelta.dx);
          print(event.scrollDelta.dy);

          if (event.scrollDelta.dy != 0) {
            // horizontal scroll
            final offset = _horizontalController.jumpTo(
              _horizontalController.offset + event.scrollDelta.dy,
            );
          }
        }
      },
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        scrollBehavior: MyCustomScrollBehavior(),
        controller: _horizontalController,
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.widgetList[index]);
          }, childCount: widget.widgetList.length))
        ],
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

ScrollController customScrollController() {
  var sc = ScrollController();

  Listener(onPointerSignal: (event) {
    if (event is PointerScrollEvent) {
      if (event.scrollDelta.dx != 0) {
        // horizontal scroll
        sc.jumpTo(
          sc.offset + event.scrollDelta.dx,
        );
      }
    }
  });

  return sc;
}
