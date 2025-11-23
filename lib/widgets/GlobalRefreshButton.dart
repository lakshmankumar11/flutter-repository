import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefreshIconButton extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final String tooltip;
  final String? snackMessage;

  const RefreshIconButton({
    Key? key,
    required this.onRefresh,
    this.tooltip = "Refresh",
    this.snackMessage,
  }) : super(key: key);

  @override
  State<RefreshIconButton> createState() => _RefreshIconButtonState();
}

class _RefreshIconButtonState extends State<RefreshIconButton>
    with SingleTickerProviderStateMixin {
  bool _isRefreshing = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // Keep it running, we'll stop it manually
    _controller.stop(); // start stopped
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    _controller.repeat();

    try {
      await widget.onRefresh();
      if (widget.snackMessage != null) {
        Get.snackbar("Refreshed", widget.snackMessage!,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to refresh",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }

    _controller.stop();
    setState(() => _isRefreshing = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: widget.tooltip,
      onPressed: _isRefreshing ? null : _handleRefresh,
      icon: _isRefreshing
          ? RotationTransition(
              turns: _controller,
              child: const Icon(Icons.refresh),
            )
          : const Icon(Icons.refresh),
    );
  }
}
