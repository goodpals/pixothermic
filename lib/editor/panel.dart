import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  final Widget child;
  final bool active;

  const Panel({
    required this.child,
    this.active = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? Colors.yellow.withOpacity(0.5) : Colors.transparent,
          width: 1,
        ),
        color: Colors.blueGrey.shade600,
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: child,
    );
  }
}
