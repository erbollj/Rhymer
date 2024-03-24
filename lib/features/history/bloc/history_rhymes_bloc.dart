import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rhymer/repo/history/history.dart';

part 'history_rhymes_event.dart';
part 'history_rhymes_state.dart';

class HistoryRhymesBloc extends Bloc<HistoryRhymesEvent, HistoryRhymesState> {
  HistoryRhymesBloc({
    required HistoryRepoInterface historyRepo,
  })  : _historyRepo = historyRepo,
        super(HistoryRhymesInitial()) {
    on<LoadHistoryRhymes>(_load);
    on<ClearRhymesHistory>(_clear);
  }

  final HistoryRepoInterface _historyRepo;

  Future<void> _load(
    LoadHistoryRhymes state,
    Emitter<HistoryRhymesState> emit,
  ) async {
    try {
      emit(HistoryRhymesLoading());
      final rhymes = await _historyRepo.getRhymesList();
      emit(HistoryRhymesLoaded(rhymes: rhymes));
    } catch (e) {
      emit(HistoryRhymesFailure(error: e));
    }
  }

  Future<void> _clear(
    ClearRhymesHistory state,
    Emitter<HistoryRhymesState> emit,
  ) async {
    try {
      await _historyRepo.clear();
      add(LoadHistoryRhymes());
    } catch (e) {
      log(e.toString());
    }
  }
}
