part of 'rhymes_list_bloc.dart';

sealed class RhymesListEvent extends Equatable {
  const RhymesListEvent();

  @override
  List<Object?> get props => [];
}

final class SearchRhymes extends RhymesListEvent {
  const SearchRhymes({required this.query});

  final String query;

  @override
  List<Object?> get props => super.props..addAll([query]);
}

final class ToggleFavoriteRhymes extends RhymesListEvent {
  const ToggleFavoriteRhymes({
    required this.rhymes,
    required this.query,
    required this.favoriteWord,
    this.completer,
  });

  final String query;
  final String favoriteWord;
  final List<String> rhymes;
  final Completer? completer;

  @override
  List<Object?> get props =>
      super.props..addAll([rhymes, query, favoriteWord, completer]);
}
