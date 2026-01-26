import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget {
  final String imageUrl;

  const DetailImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 500;

    return AspectRatio(
      aspectRatio: isTablet ? 16 / 7 : 16 / 9,
      child: Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }
}
