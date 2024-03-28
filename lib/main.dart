import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:realm/realm.dart';
import 'package:rhymer/api/api.dart';
import 'package:rhymer/bloc/theme/theme_cubit.dart';
import 'package:rhymer/features/favorites/bloc/favorite_rhymes_bloc.dart';
import 'package:rhymer/features/search/bloc/rhymes_list_bloc.dart';
import 'package:rhymer/repo/favorite/favorite.dart';
import 'package:rhymer/repo/history/history.dart';
import 'package:rhymer/repo/settings/settings.dart';
import 'package:rhymer/router/router.dart';
import 'package:rhymer/ui/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/history/bloc/history_rhymes_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final config = Configuration.local([
    HistoryRhymes.schema,
    FavoriteRhymes.schema,
  ]);
  final realm = Realm(config);
  final prefs = await SharedPreferences.getInstance();
  runApp(RhymerApp(realm: realm, prefs: prefs,));
}

class RhymerApp extends StatefulWidget {
  const RhymerApp({super.key, required this.realm, required this.prefs,});

  final Realm realm;
  final SharedPreferences prefs;

  @override
  State<RhymerApp> createState() => _RhymerAppState();
}

class _RhymerAppState extends State<RhymerApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    final historyRepo = HistoryRepo(realm: widget.realm);
    final favoriteRepo = FavoriteRepo(realm: widget.realm);
    final settingsRepo = SettingsRepo(prefs: widget.prefs);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RhymesListBloc(
            apiClient: RhymerApiClient.create(apiKey: dotenv.env["API_KEY"]),
            historyRepo: historyRepo,
            favoriteRepo: favoriteRepo,
          ),
        ),
        BlocProvider(
          create: (context) => HistoryRhymesBloc(
            historyRepo: historyRepo,
          ),
        ),
        BlocProvider(
          create: (context) => FavoriteRhymesBloc(
            favoriteRepo: favoriteRepo,
          ),
        ),
        BlocProvider(create: (context) => ThemeCubit(settingsRepo: settingsRepo)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
  builder: (context, state) {
    return MaterialApp.router(
        title: 'Rhymer',
        theme: state.isDark ? darkTheme : lightTheme,
        routerConfig: _router.config(),
      );
  },
),
    );
  }
}
