import 'package:rhymer/repo/history/history.dart';

abstract interface class HistoryRepoInterface {
  Future<List<HistoryRhymes>> getRhymesList();
  Future<void> setRhymes(HistoryRhymes rhymes);
  Future<void> clear();
}