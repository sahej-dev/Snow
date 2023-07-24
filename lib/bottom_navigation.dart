import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './constants/strings.dart';
import './constants/ui.dart';
import './bloc/contests_bloc.dart';
import './home_page/home_page.dart';
import './settings_page/settings_page.dart';
import './favorites_page/favorites_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedPageIndex = 0;
  final HomePage _homePage = const HomePage();
  final FavoritesPage _favoritesPage = const FavoritesPage();
  final SettingsPage _settingsPage = const SettingsPage();

  String _getTitle(Widget screen) {
    switch (screen.runtimeType) {
      case HomePage:
        return HomePageConstants.appBarTitle;
      case FavoritesPage:
        return FavoritesPageConstants.appBarTitle;
      case SettingsPage:
        return SettingsConstants.appBarTitle;
      default:
        return '';
    }
  }

  void _setPage(int i) {
    setState(() {
      _selectedPageIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    List screens = [
      _homePage,
      _favoritesPage,
      _settingsPage,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(screens[_selectedPageIndex])),
        actions: [
          BlocBuilder<ContestsBloc, ContestsState>(
            builder: (context, state) {
              if (state is! ContestsStateLoaded || _selectedPageIndex != 0) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kdefaultPadding * 1.5),
                child: PopupMenuButton<ContestsSortBy>(
                  child: const Icon(Icons.sort),
                  itemBuilder: (context) => ContestsSortBy.values
                      .map(
                        (value) => PopupMenuItem<ContestsSortBy>(
                          value: value,
                          // IIFE trickery
                          child: Text((() {
                            switch (value) {
                              case ContestsSortBy.nearestFirst:
                                return 'Nearest first';
                              case ContestsSortBy.nearestLast:
                                return 'Nearest last';
                              case ContestsSortBy.shorterFirst:
                                return 'Shortest first';
                              case ContestsSortBy.longerFirst:
                                return 'Longest first';
                              default:
                                return value.name;
                            }
                          })()),
                        ),
                      )
                      .toList(),
                  onSelected: (value) {
                    context
                        .read<ContestsBloc>()
                        .add(ContestsEventSortByRequested(value));
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: screens[_selectedPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (int i) => _setPage(i),
        destinations: const [
          NavigationDestination(
            label: HomePageConstants.bottomNavBarTitle,
            icon: Icon(Icons.home_filled),
          ),
          NavigationDestination(
            label: FavoritesPageConstants.bottomNavBarTitle,
            icon: Icon(Icons.favorite_rounded),
          ),
          NavigationDestination(
            label: SettingsConstants.bottomNavBarTitle,
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: screens[_selectedPageIndex] is HomePage
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    builder: (context) {
                      return const FiltersBottomSheet();
                    });
              },
              child: const Icon(Icons.filter_list_alt),
            )
          : null,
    );
  }
}
