import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rhymer/repo/favorite/favorite.dart';

part 'favorite_rhymes_event.dart';

part 'favorite_rhymes_state.dart';

class FavoriteRhymesBloc
    extends Bloc<FavoriteRhymesEvent, FavoriteRhymesState> {
  FavoriteRhymesBloc({
    required FavoriteRepoInterface favoriteRepo,
  })  : _favoriteRepo = favoriteRepo,
        super(FavoriteRhymesInitial()) {
    on<LoadFavoriteRhymes>(_load);
  }

  final FavoriteRepoInterface _favoriteRepo;

  FutureOr<void> _load(
    LoadFavoriteRhymes event,
    Emitter<FavoriteRhymesState> emit,
  ) async {
    try {
      emit(FavoriteRhymesLoading());
      final rhymes = await _favoriteRepo.getRhymesList();
      emit(FavoriteRhymesLoaded(rhymes: rhymes));
    } catch (e) {
      emit(FavoriteRhymesFailure(error: e));
    }
  }
}
