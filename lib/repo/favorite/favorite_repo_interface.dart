import 'package:rhymer/repo/favorite/favorite.dart';

abstract interface class FavoriteRepoInterface {
  Future<List<FavoriteRhymes>> getRhymesList();
  Future<void> createOrDeleteRhymes(FavoriteRhymes rhymes);
  Future<void> clear();
}