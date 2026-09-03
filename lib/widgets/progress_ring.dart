import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress; // 0..1
  final double size;
  final String centerText;
  final String? subText;
  final Color? color;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 140,
    required this.centerText,
    this.subText,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ringColor = color ?? scheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress.clamp(0, 1),
              strokeWidth: 10,
              backgroundColor: ringColor.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(ringColor),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerText,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (subText != null)
                Text(subText!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
