import 'package:flutter/widgets.dart';

class CustomSliverChildDelegate extends SliverChildDelegate {
  final int childCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  CustomSliverChildDelegate({
    required this.childCount,
    required this.itemBuilder,
  });

  @override
  int get estimatedChildCount => childCount;

  @override
  Widget build(BuildContext context, int index) {
    if (index < 0 || index >= childCount) {
      return const SizedBox.shrink();
    }
    return itemBuilder(context, index);
  }

  @override
  bool shouldRebuild(covariant SliverChildDelegate oldDelegate) {
    return oldDelegate is! CustomSliverChildDelegate ||
           oldDelegate.childCount != childCount ||
           oldDelegate.itemBuilder != itemBuilder;
  }
}

// For SliverFixedExtentList
class CustomSliverChildDelegateFixed extends SliverChildDelegate {
  final int childCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double itemExtent;

  CustomSliverChildDelegateFixed({
    required this.childCount,
    required this.itemBuilder,
    required this.itemExtent,
  });

  @override
  int get estimatedChildCount => childCount;

  @override
  Widget build(BuildContext context, int index) {
    if (index < 0 || index >= childCount) {
      return const SizedBox.shrink();
    }
    return itemBuilder(context, index);
  }

  @override
  bool shouldRebuild(covariant SliverChildDelegate oldDelegate) {
    return oldDelegate is! CustomSliverChildDelegateFixed ||
           oldDelegate.childCount != childCount ||
           oldDelegate.itemBuilder != itemBuilder ||
           oldDelegate.itemExtent != itemExtent;
  }
}
