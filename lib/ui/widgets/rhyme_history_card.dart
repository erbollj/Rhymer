import 'package:flutter/material.dart';
import 'package:rhymer/ui/ui.dart';

class RhymeHistoryCard extends StatelessWidget {
  const RhymeHistoryCard({
    super.key,
    required this.rhymes,
  });

  final List<String> rhymes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseContainer(
      padding: const EdgeInsets.all(16),
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Слово",
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          Flexible(
            child: Text(
              rhymes.map((e) => "$e, ").join(),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),
          // Wrap(
          //   spacing: 6,
          //   children: rhymes.map((e) => Text(e)).toList(),
          // ),
        ],
      ),
    );
  }
}
