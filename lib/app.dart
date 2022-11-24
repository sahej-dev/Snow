import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:contests_repository/contests_repository.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import './constants/ui.dart';
import './constants/strings.dart';
import './bottom_navigation.dart';
import './bloc/contests_bloc.dart';
import './bloc/settings_bloc.dart';
import './bloc/notifications_bloc.dart';

class SnowApp extends StatelessWidget {
  const SnowApp({
    Key? key,
    required contestsRepository,
    required notificationsPlugin,
  })  : _contestsRepository = contestsRepository,
        _notificationsPlugin = notificationsPlugin,
        super(key: key);

  final ContestsRepository _contestsRepository;
  final AwesomeNotifications _notificationsPlugin;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _contestsRepository,
        ),
        RepositoryProvider.value(
          value: _notificationsPlugin,
        ),
      ],
      child: const MaterialAppWrapper(),
    );
  }
}

class MaterialAppWrapper extends StatelessWidget {
  const MaterialAppWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ContestsBloc(
            contestsRepository: context.read<ContestsRepository>(),
          )..add(const ContestsEventLoadRequested(true)),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(),
        ),
        BlocProvider(
          create: (context) => NotificationsBloc(
            context.read<AwesomeNotifications>(),
          ),
          // ..add(const NotificationsEventPermissionsAskedCheckRequested()),
        )
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({
    Key? key,
  }) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  ContestsRepository? _contestsRepository;
  ContestsBloc? _contestsBloc;
  NotificationsBloc? _notificationsBloc;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _contestsRepository?.cacheContests();
    }

    if (state == AppLifecycleState.resumed) {
      if (_contestsBloc != null &&
          _contestsBloc?.state.favoriteContests != null) {
        _notificationsBloc?.add(
          NotificationsEventTrySchedulingUnscheduled(
              _contestsBloc!.state.favoriteContests),
        );
      }
    }
    log('state is ${state.name}');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _contestsRepository ??= context.read<ContestsRepository>();
    _contestsBloc ??= context.read<ContestsBloc>();
    _notificationsBloc ??= context.read<NotificationsBloc>();
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) =>
          BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          ColorScheme lightCustomColorScheme =
              ColorScheme.fromSeed(seedColor: state.accentColor).harmonized();
          ColorScheme darkCustomColorScheme = ColorScheme.fromSeed(
            seedColor: state.accentColor,
            brightness: Brightness.dark,
          ).harmonized();

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppWideConstacts.appTitle,
            theme: ThemeData(
              colorScheme:
                  state.accentColorSource != AccentColorSource.material3
                      ? lightCustomColorScheme
                      : lightDynamic?.harmonized() ?? lightCustomColorScheme,
              iconTheme: const IconThemeData(
                size: kdefaultIconSize,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme:
                  state.accentColorSource != AccentColorSource.material3
                      ? darkCustomColorScheme.harmonized()
                      : darkDynamic?.harmonized() ??
                          darkCustomColorScheme.harmonized(),
              iconTheme: const IconThemeData(
                size: kdefaultIconSize,
              ),
              useMaterial3: true,
            ),
            themeMode: state.themeMode,
            home: const BottomNavigation(),
          );
        },
      ),
    );
  }
}
