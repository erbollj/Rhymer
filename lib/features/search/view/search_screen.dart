import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:rhymer/features/search/widgets/widgets.dart';
import 'package:rhymer/ui/ui.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({
    super.key,
  });

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
          child: SizedBox(
            height: 100,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                width: 16,
              ),
              padding: const EdgeInsets.only(left: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                final rhymes = List.generate(4, (index) => "Рифма $index");
                return RhymeHistoryCard(rhymes: rhymes);
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 16,
          ),
        ),
        SliverList.builder(
            itemBuilder: (context, index) => const RhymeListCard(
                  rhyme: "Рифма",
                )),
      ],
    );
  }

  Future<dynamic> _showSearchBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (context) => const Padding(
        padding: EdgeInsets.only(top: 60),
        child: SearchRhymesBottomSheet(),
      ),
    );
  }
}
