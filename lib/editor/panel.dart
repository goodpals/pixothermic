import 'package:flutter/material.dart';

class Panel extends StatefulWidget {
  final String? title;
  final Widget? icon;
  final bool minimisable;
  final Widget child;
  final bool active;

  const Panel({
    this.title,
    this.icon,
    this.minimisable = true,
    required this.child,
    this.active = false,
    super.key,
  });

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  bool minimised = false;

  void _toggleMinimised() => setState(() => minimised = !minimised);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.active
              ? IconTheme.of(context).color ?? Colors.yellow
              : Colors.transparent,
          width: 1,
        ),
        color: Colors.blueGrey.shade600,
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.title != null)
            InkWell(
              onTap: widget.minimisable ? _toggleMinimised : null,
              child: Row(
                children: [
                  if (widget.icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: widget.icon!,
                    ),
                  Text(
                    widget.title!,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  if (widget.minimisable)
                    Icon(minimised ? Icons.add : Icons.remove),
                ],
              ),
            ),
          if (!minimised) widget.child,
        ],
      ),
    );
  }
}
