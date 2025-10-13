import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/responsive/size_helper_extension.dart';

class CacheImage extends StatelessWidget {
  final String imageUrl;
  const CacheImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: context.setWidth(25),
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width:  50,
          height:  50,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (context, url, error) =>  Icon(
            Icons.image_not_supported_rounded,
            color: Colors.grey,
            size:  context.setWidth(24),
          ),
        ),
      ),
    );
  }
}
