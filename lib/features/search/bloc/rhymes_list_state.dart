part of 'rhymes_list_bloc.dart';

sealed class RhymesListState extends Equatable {
  const RhymesListState();

  @override
  List<Object> get props => [];
}

class RhymesListInitial extends RhymesListState {}

class RhymesListLoading extends RhymesListState {}

class RhymesListLoaded extends RhymesListState {
  const RhymesListLoaded(this.rhymes);

  final List<String> rhymes;

  @override
  List<Object> get props => super.props..add(rhymes);
}

class RhymesListFailure extends RhymesListState {
  const RhymesListFailure(this.error);

  final Object error;

  @override
  List<Object> get props => super.props..add(error);
}
