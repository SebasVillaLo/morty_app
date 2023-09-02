import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../views/views.dart';

class CardCharacterWidget extends StatelessWidget {
  const CardCharacterWidget({super.key, required this.character});

  final CharactersModel character;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CharactersDetails(
            character: character,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 159,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                character.image,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              character.name,
              style: textStyle.titleMedium,
              maxLines: 2,
            ),
            Text(character.status, style: textStyle.bodySmall),
          ],
        ),
      ),
    );
  }
}
