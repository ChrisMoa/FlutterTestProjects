import 'package:flutter/material.dart';

/// A widget that displays a line of text that can be expanded or collapsed
/// to show or hide the full text if it overflows the available width.
class LineWrappingTextWidget extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? textStyle;

  const LineWrappingTextWidget({super.key, required this.text, this.maxLines = 1, this.textStyle});

  @override
  // ignore: library_private_types_in_public_api
  _LineWrappingTextWidgetState createState() => _LineWrappingTextWidgetState();
}

class _LineWrappingTextWidgetState extends State<LineWrappingTextWidget> {
  bool _isExpanded = false;
  bool _isOverflowing = false;
  TextStyle? textStyle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(_) {
    final span = TextSpan(
      text: widget.text,
      style: textStyle,
    );

    final tp = TextPainter(
      text: span,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: context.size!.width);
    setState(() {
      _isOverflowing = tp.didExceedMaxLines;
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    textStyle = widget.textStyle ?? Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isExpanded
            ? Text(
                widget.text,
                style: textStyle,
              )
            : Text(
                widget.text,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
                maxLines: widget.maxLines,
              ),
        if (_isOverflowing)
          GestureDetector(
            onTap: _toggleExpanded,
            child: Text(
              _isExpanded ? 'Show less' : 'Show more',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.surfaceContainerLowest),
            ),
          ),
      ],
    );
  }
}
