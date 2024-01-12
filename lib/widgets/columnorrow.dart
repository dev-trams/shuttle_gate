import 'package:flutter/material.dart';

class ColOrRowWidget extends StatelessWidget {
  final bool state;
  final List<Widget> children;
  const ColOrRowWidget(
      {super.key, required this.state, required this.children});
  @override
  Widget build(BuildContext context) {
    return state
        ? Row(
            children: children,
          )
        : Column(
            children: children,
          );
  }
}
