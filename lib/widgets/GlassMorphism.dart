import 'dart:ui';
import 'package:flutter/material.dart';
class GlassMorphism extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const GlassMorphism({Key? key, required this.child, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            BackdropFilter(filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
              child: const SizedBox(),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.1),
                  ]
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(15),
            child: child),
          ],
        ),
      ),
    );
  }
}
