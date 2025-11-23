import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double velocity;
  final double blankSpace;
  final Axis direction;

  const MarqueeWidget({
    super.key,
    required this.text,
    this.style,
    this.velocity = 50.0,
    this.blankSpace = 50.0,
    this.direction = Axis.horizontal,
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Start scrolling after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _startScroll();
      }
    });
  }

  void _startScroll() async {
    while (mounted) {
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        if (!_scrollController.hasClients) return;

        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(
            seconds: (_scrollController.position.maxScrollExtent ~/ widget.velocity).toInt(),
          ),
          curve: Curves.linear,
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (!_scrollController.hasClients) return;

        _scrollController.jumpTo(0);
      } catch (e) {
        // ScrollController might not be attached yet
        break;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.direction == Axis.horizontal ? 30 : null,
      child: ListView(
        scrollDirection: widget.direction,
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            children: [
              Text(widget.text, style: widget.style),
              SizedBox(width: widget.blankSpace),
              Text(widget.text, style: widget.style),
            ],
          ),
        ],
      ),
    );
  }
}
