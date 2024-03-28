import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rhymer/ui/ui.dart';

import '../bloc/favorite_rhymes_bloc.dart';

@RoutePage()
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    BlocProvider.of<FavoriteRhymesBloc>(context).add(LoadFavoriteRhymes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            snap: true,
            floating: true,
            title: Text("Избранное"),
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          BlocBuilder<FavoriteRhymesBloc, FavoriteRhymesState>(
            builder: (context, state) {
              if (state is FavoriteRhymesLoaded) {
                return SliverList.builder(
                  itemCount: state.rhymes.length,
                  itemBuilder: (context, index) {
                    final rhyme = state.rhymes[index];
                    return RhymeListCard(
                      rhyme: rhyme.favoriteWord,
                      isFavorite: true,
                      sourceWord: rhyme.queryWord,
                      onTap: () {},
                    );
                  },
                );
              }
              return const SliverFillRemaining(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
