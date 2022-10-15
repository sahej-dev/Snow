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
          BlocSelector<SettingsBloc, SettingsState, ThemeMode>(
        selector: (state) {
          return state.themeMode;
        },
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppWideConstacts.appTitle,
            theme: ThemeData(
              colorScheme: lightDynamic ??
                  const ColorScheme(
                    brightness: Brightness.light,
                    primary: Color(0xff5331ff),
                    onPrimary: Color(0xffc6bfff),
                    primaryContainer: Color(0xffe4dfff),
                    onPrimaryContainer: Color(0xff160066),
                    secondary: Color(0xff66587b),
                    onSecondary: Color(0xffffffff),
                    secondaryContainer: Color(0xffecdcff),
                    onSecondaryContainer: Color(0xff211534),
                    tertiary: Color(0xff73527f),
                    onTertiary: Color(0xffffffff),
                    tertiaryContainer: Color(0xfff8d8ff),
                    onTertiaryContainer: Color(0xff2b0e38),
                    error: Color(0xffba1a1a),
                    onError: Color(0xffe5e0ef),
                    errorContainer: Color(0xffffdad6),
                    onErrorContainer: Color(0xff410002),
                    background: Color(0xfffffbff),
                    onBackground: Color(0xff1c1a25),
                    surface: Color(0xfffffbff),
                    onSurface: Color(0xff1c1a25),
                    surfaceVariant: Color(0xffe5e0f2),
                    onSurfaceVariant: Color(0xff474554),
                    outline: Color(0xff777484),
                    outlineVariant: Color(0xff1c1a25),
                    inverseSurface: Color(0xff312f3a),
                    onInverseSurface: Color(0xfff3eefd),
                    inversePrimary: Color(0xffc6bfff),
                    primaryVariant: Color(0xff5331ff),
                    secondaryVariant: Color(0xff66587b),
                    surfaceTint: Color(0xff5331ff),
                  ),
              iconTheme: const IconThemeData(
                size: kdefaultIconSize,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkDynamic ??
                  const ColorScheme(
                    brightness: Brightness.dark,
                    primary: Color(0xffcabeff),
                    onPrimary: Color(0xff322075),
                    primaryContainer: Color(0xff49398c),
                    onPrimaryContainer: Color(0xffe6deff),
                    secondary: Color(0xffcac3dc),
                    onSecondary: Color(0xff312e41),
                    secondaryContainer: Color(0xff484458),
                    onSecondaryContainer: Color(0xffe6dff9),
                    tertiary: Color(0xffedb8cc),
                    onTertiary: Color(0xff492535),
                    tertiaryContainer: Color(0xff623b4b),
                    onTertiaryContainer: Color(0xffffd8e5),
                    error: Color(0xffffb4ab),
                    onError: Color(0xff690005),
                    errorContainer: Color(0xff93000a),
                    onErrorContainer: Color(0xffffb4ab),
                    background: Color(0xff1b1b1b),
                    onBackground: Color(0xffe2e2e2),
                    surface: Color(0xff1b1b1b),
                    onSurface: Color(0xffe2e2e2),
                    surfaceVariant: Color(0xff474747),
                    onSurfaceVariant: Color(0xffc6c6c6),
                    outline: Color(0xff919191),
                    outlineVariant: Color(0xffe2e2e2),
                    inverseSurface: Color(0xffe2e2e2),
                    onInverseSurface: Color(0xff303030),
                    inversePrimary: Color(0xff6152a6),
                    primaryVariant: Color(0xffcabeff),
                    secondaryVariant: Color(0xffcac3dc),
                    surfaceTint: Color(0xffcabeff),
                  ),
              iconTheme: const IconThemeData(
                size: kdefaultIconSize,
              ),
              useMaterial3: true,
            ),
            themeMode: themeMode,
            home: const BottomNavigation(),
          );
        },
      ),
    );
  }
}
