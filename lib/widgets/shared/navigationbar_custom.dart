import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigator_scope/navigator_scope.dart';

import '../../providers/providers.dart';
import '../../views/views.dart';

class NavigationbarCustom extends ConsumerStatefulWidget {
  const NavigationbarCustom({super.key});

  static final List<Widget> _buildScreens = [
    const CharacterView(),
    const EpisodeView(),
    const LocationView(),
  ];

  @override
  ConsumerState<NavigationbarCustom> createState() =>
      _NavigationbarCustomState();
}

class _NavigationbarCustomState extends ConsumerState<NavigationbarCustom> {
  @override
  Widget build(BuildContext context) {
    final navbarState = ref.watch(navbarStateNotifierProvider);
    final navbarProvider = ref.watch(navbarStateNotifierProvider.notifier);

    return Scaffold(
      bottomNavigationBar: WillPopScope(
        onWillPop: ref.read(navbarStateNotifierProvider.notifier).onWillPop,
        child: NavigationBarTheme(
          data: const NavigationBarThemeData(),
          child: NavigationBar(
            selectedIndex: navbarState.currentTab,
            destinations: navbarProvider.tabs,
            onDestinationSelected:
                ref.read(navbarStateNotifierProvider.notifier).onTabSelected,
            animationDuration: const Duration(milliseconds: 500),
            surfaceTintColor: Colors.transparent,
          ),
        ),
      ),
      body: NavigatorScope(
        currentDestination: navbarState.currentTab,
        destinationCount: navbarProvider.tabs.length,
        destinationBuilder: (context, index) {
          return NestedNavigator(
            navigatorKey: navbarProvider.navigatorKeys[index],
            builder: (context) {
              return NavigationbarCustom._buildScreens[index];
            },
          );
        },
      ),
    );
  }
}
