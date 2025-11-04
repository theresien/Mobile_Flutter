import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernLoading extends StatefulWidget {
  final double size;
  final Color? color;

  const ModernLoading({
    super.key,
    this.size = 40,
    this.color,
  });

  @override
  State<ModernLoading> createState() => _ModernLoadingState();
}

class _ModernLoadingState extends State<ModernLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              for (int i = 0; i < 3; i++)
                Positioned.fill(
                  child: Transform.rotate(
                    angle: (i * 2.094) + (_animation.value * 6.283),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: widget.size * 0.15,
                        height: widget.size * 0.15,
                        decoration: BoxDecoration(
                          color: (widget.color ?? AppTheme.primaryColor)
                              .withOpacity(0.8 - (i * 0.2)),
                          borderRadius: BorderRadius.circular(widget.size * 0.075),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}