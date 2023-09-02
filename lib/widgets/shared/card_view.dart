import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  const CardView({
    super.key,
    this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String? image;
  final String title;
  final String subtitle;
  final void Function()? onTap;

  final loaderImage = const AssetImage('assets/loader/bottle-loader.gif');

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colors.surface,
          ),
          child: Row(
            children: [
              if (image != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholderFit: BoxFit.cover,
                    placeholder: loaderImage,
                    image: NetworkImage(image!),
                    height: size.width * 0.2,
                    width: size.width * 0.2,
                  ),
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.bodyMedium,
                    ),
                    Text(subtitle, style: textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
              )
            ],
          ),
        ),
      ),
    );
  }
}
