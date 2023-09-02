import 'package:flutter/material.dart';

class ScaffoldWithAppBar extends StatelessWidget {
  const ScaffoldWithAppBar({
    super.key,
    required this.title,
    required this.child,
    this.backButton = false,
    this.onPressedSearch,
  });

  final String title;
  final Widget child;
  final bool backButton;
  final void Function()? onPressedSearch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: backButton
            ? IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_rounded),
              )
            : null,
        actions: [
          if (!backButton)
            IconButton(
              onPressed: onPressedSearch,
              icon: const Icon(Icons.search_rounded),
            ),
        ],
      ),
      body: child,
    );
  }
}
