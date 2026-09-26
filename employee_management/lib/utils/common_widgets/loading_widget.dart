import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color baseColor;
  final Color highlightColor;
  const LoadingWidget({
    super.key,
    required this.width,
    required this.height,
    this.radius = 0.0,
    this.baseColor = const Color(0xFFdadada),
    this.highlightColor = const Color(0xFFc6d1e7),
  });
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }
}
