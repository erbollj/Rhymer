import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realm/realm.dart';
import 'package:rhymer/api/api.dart';
import 'package:rhymer/repo/favorite/favorite.dart';
import 'package:rhymer/repo/history/history.dart';

part 'rhymes_list_event.dart';

part 'rhymes_list_state.dart';

class RhymesListBloc extends Bloc<RhymesListEvent, RhymesListState> {
  RhymesListBloc({
    required RhymerApiClient apiClient,
    required HistoryRepoInterface historyRepo,
    required FavoriteRepoInterface favoriteRepo,
  })  : _historyRepo = historyRepo,
        _favoriteRepo = favoriteRepo,
        _apiClient = apiClient,
        super(RhymesListInitial()) {
    on<SearchRhymes>(_onSearch);
    on<ToggleFavoriteRhymes>(_onToggleFavorite);
  }

  final RhymerApiClient _apiClient;
  final HistoryRepoInterface _historyRepo;
  final FavoriteRepoInterface _favoriteRepo;

  Future<void> _onSearch(
    SearchRhymes event,
    Emitter<RhymesListState> emit,
  ) async {
    try {
      emit(RhymesListLoading());
      final rhymes = await _apiClient.getRhymesList(event.query);
      final historyRhymes =
          HistoryRhymes(Uuid.v4().toString(), event.query, words: rhymes);
      await _historyRepo.setRhymes(historyRhymes);
      final favoriteRhymes = await _favoriteRepo.getRhymesList();
      emit(RhymesListLoaded(
        rhymes: rhymes,
        query: event.query,
        favoriteRhymes: favoriteRhymes,
      ));
    } catch (e) {
      emit(RhymesListFailure(e));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteRhymes event,
    Emitter<RhymesListState> emit,
  ) async {
    try {
      final prevState = state;
      if (prevState is! RhymesListLoaded) {
        log("State is not RhymesListLoaded");
        return;
      }
      final favoriteRhymesModel = FavoriteRhymes(
          Uuid.v4().toString(), event.query, event.favoriteWord, DateTime.now(),
          words: event.rhymes);
      await _favoriteRepo.createOrDeleteRhymes(favoriteRhymesModel);
      final favoriteRhymes = await _favoriteRepo.getRhymesList();
      emit(prevState.copyWith(favoriteRhymes: favoriteRhymes));
    } catch (e) {
      emit(RhymesListFailure(e));
    } finally {
      event.completer?.complete();
    }
  }
}
