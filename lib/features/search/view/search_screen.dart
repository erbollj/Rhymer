import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rhymer/features/favorites/bloc/favorite_rhymes_bloc.dart';
import 'package:rhymer/features/search/bloc/rhymes_list_bloc.dart';
import 'package:rhymer/features/search/widgets/widgets.dart';
import 'package:rhymer/ui/ui.dart';

import '../../history/bloc/history_rhymes_bloc.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    BlocProvider.of<HistoryRhymesBloc>(context).add(LoadHistoryRhymes());
    super.initState();
  }

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          snap: true,
          floating: true,
          title: const Text("Rhymer"),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: SearchButton(
              controller: _searchController,
              onTap: () => _showSearchBottomSheet(context),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 16,
          ),
        ),
        SliverToBoxAdapter(
          child: BlocBuilder<HistoryRhymesBloc, HistoryRhymesState>(
            builder: (context, state) {
              if (state is! HistoryRhymesLoaded) return const SizedBox();
              return SizedBox(
                height: 100,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 16,
                  ),
                  padding: const EdgeInsets.only(left: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.rhymes.length,
                  itemBuilder: (context, index) {
                    final rhymes = state.rhymes[index];
                    return RhymeHistoryCard(
                      rhymes: rhymes.words,
                      word: rhymes.word,
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 16,
          ),
        ),
        BlocConsumer<RhymesListBloc, RhymesListState>(
          listener: _handleRhymesListState,
          bloc: BlocProvider.of<RhymesListBloc>(context),
          builder: (context, state) {
            if (state is RhymesListLoaded) {
              final rhymes = state.rhymes;
              return SliverList.builder(
                  itemCount: rhymes.length,
                  itemBuilder: (context, index) {
                    final rhyme = rhymes[index];
                    return RhymeListCard(
                      isFavorite: state.isFavorite(rhyme),
                      rhyme: rhyme,
                      onTap: () =>
                          _toggleFavorite(context, rhymes, state, rhyme),
                    );
                  });
            }
            if (state is RhymesListInitial) {
              return const SliverFillRemaining(
                child: RhymesListInitialBanner(),
              );
            }
            return const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        )
      ],
    );
  }

  Future<void> _toggleFavorite(
    BuildContext context,
    List<String> rhymes,
    RhymesListLoaded state,
    String currentRhyme,
  ) async {
    final rhymesListBloc = BlocProvider.of<RhymesListBloc>(context);
    final favoriteRhymesBloc = BlocProvider.of<FavoriteRhymesBloc>(context);

    final completer = Completer();
    rhymesListBloc.add(
      ToggleFavoriteRhymes(
        rhymes: rhymes,
        query: state.query,
        favoriteWord: currentRhyme,
        completer: completer,
      ),
    );
    await completer.future;
    favoriteRhymesBloc.add(LoadFavoriteRhymes());
  }

  void _handleRhymesListState(
    BuildContext context,
    RhymesListState state,
  ) {
    if (state is RhymesListLoaded) {
      BlocProvider.of<HistoryRhymesBloc>(context).add(LoadHistoryRhymes());
    }
  }

  Future<void> _showSearchBottomSheet(BuildContext context) async {
    final bloc = BlocProvider.of<RhymesListBloc>(context);
    final query = await showModalBottomSheet<String>(
      isScrollControlled: true,
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 60),
        child: SearchRhymesBottomSheet(
          controller: _searchController,
        ),
      ),
    );
    if (query?.isNotEmpty ?? false) {
      bloc.add(SearchRhymes(query: query!));
    }
  }
}
