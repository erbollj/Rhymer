import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realm/realm.dart';
import 'package:rhymer/api/api.dart';
import 'package:rhymer/repo/history/history.dart';

part 'rhymes_list_event.dart';
part 'rhymes_list_state.dart';

class RhymesListBloc extends Bloc<RhymesListEvent, RhymesListState> {
  RhymesListBloc({
    required RhymerApiClient apiClient,
    required HistoryRepoInterface historyRepo,
  })  : _historyRepo = historyRepo,
        _apiClient = apiClient,
        super(RhymesListInitial()) {
    on<SearchRhymes>(_onSearch);
  }

  final RhymerApiClient _apiClient;
  final HistoryRepoInterface _historyRepo;

  Future<void> _onSearch(
    SearchRhymes event,
    Emitter<RhymesListState> emit,
  ) async {
    try {
      emit(RhymesListLoading());
      final rhymes = await _apiClient.getRhymesList(event.query);
      final historyRhymes =
          HistoryRhymes(Uuid.v4().toString(), event.query, words: rhymes);
      _historyRepo.setRhymes(historyRhymes);
      emit(RhymesListLoaded(rhymes));
    } catch (e) {
      emit(RhymesListFailure(e));
    }
  }
}
