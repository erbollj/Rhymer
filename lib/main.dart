import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:realm/realm.dart';
import 'package:rhymer/api/api.dart';
import 'package:rhymer/features/search/bloc/rhymes_list_bloc.dart';
import 'package:rhymer/repo/history/history.dart';
import 'package:rhymer/router/router.dart';
import 'package:rhymer/ui/ui.dart';

import 'features/history/bloc/history_rhymes_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final config = Configuration.local([HistoryRhymes.schema]);
  final realm = Realm(config);
  runApp(RhymerApp(realm: realm));
}

class RhymerApp extends StatefulWidget {
  const RhymerApp({super.key, required this.realm});

  final Realm realm;

  @override
  State<RhymerApp> createState() => _RhymerAppState();
}

class _RhymerAppState extends State<RhymerApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    final historyRepo = HistoryRepo(realm: widget.realm);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RhymesListBloc(
            apiClient: RhymerApiClient.create(apiKey: dotenv.env["API_KEY"]),
            historyRepo: historyRepo,
          ),
        ),
        BlocProvider(
          create: (context) => HistoryRhymesBloc(
            historyRepo: historyRepo,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Rhymer',
        theme: themeData,
        routerConfig: _router.config(),
      ),
    );
  }
}
