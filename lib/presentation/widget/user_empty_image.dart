import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserEmptyImage extends ConsumerWidget {
  const UserEmptyImage({super.key, required this.radius});

  final int radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircleAvatar(
      radius: radius.r,
      backgroundColor: Colors.grey[200],
      child: Icon(
        Icons.person,
        size: radius.r,
        color: Colors.grey[500],
      ),
    );
  }
}
