import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScrollViewVertical extends StatefulWidget {
  List<Widget> widgetList;
  ScrollViewVertical(this.widgetList, {super.key});

  @override
  State<ScrollViewVertical> createState() => _ScrollViewState();
}

class _ScrollViewState extends State<ScrollViewVertical> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.widgetList[index]);
        }, childCount: widget.widgetList.length))
      ],
    );
  }
}
