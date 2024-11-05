import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserFirebaseImage extends ConsumerWidget {
  const UserFirebaseImage({
    super.key,
    required this.imageUrl,
    required this.radius,
  });

  final String? imageUrl;
  final int radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: radius.r,
      height: radius.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(imageUrl ?? ''),
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? '',
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
