import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navbarStateNotifierProvider =
    StateNotifierProvider<NavbarNotifier, NavbarState>(
        (ref) => NavbarNotifier());

class NavbarNotifier extends StateNotifier<NavbarState> {
  NavbarNotifier() : super(const NavbarState());

  final tabs = [
    const NavigationDestination(
      icon: Icon(Icons.people_alt_rounded),
      label: 'Characters',
    ),
    const NavigationDestination(
      icon: Icon(Icons.movie_filter_rounded),
      label: 'Episodes',
    ),
    const NavigationDestination(
      icon: Icon(Icons.location_on_rounded),
      label: 'Locations',
    ),
  ];

  final navigatorKeys = [
    GlobalKey<NavigatorState>(debugLabel: 'Characters tab'),
    GlobalKey<NavigatorState>(debugLabel: 'Episodes tab'),
    GlobalKey<NavigatorState>(debugLabel: 'Locations tab'),
  ];

  NavigatorState get currentNavigator =>
      navigatorKeys[state.currentTab].currentState!;

  void onTabSelected(int tab) {
    if (tab == state.currentTab && currentNavigator.canPop()) {
      currentNavigator.popUntil((route) => route.isFirst);
    } else {
      state = state.copyWith(currentTab: tab);
    }
  }

  Future<bool> onWillPop() async {
    final canPop = currentNavigator.canPop();
    if (canPop) {
      currentNavigator.pop();
    } else {
      return false;
    }
    return Future.value(!canPop);
  }
}

class NavbarState {
  const NavbarState({this.index = 0, this.currentTab = 0});
  final int index;
  final int currentTab;

  NavbarState copyWith({
    int? index,
    int? currentTab,
  }) {
    return NavbarState(
      index: index ?? this.index,
      currentTab: currentTab ?? this.currentTab,
    );
  }
}
