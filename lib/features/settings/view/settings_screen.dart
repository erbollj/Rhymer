import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:rhymer/features/settings/widgets/widgets.dart';
import 'package:rhymer/ui/ui.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            snap: true,
            floating: true,
            title: Text("Настройки"),
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          SliverToBoxAdapter(
              child: SettingsToggleCard(
            title: "Темная тема",
            value: false,
            onChanged: (v) {},
          )),
          SliverToBoxAdapter(
              child: SettingsToggleCard(
            title: "Уведомления",
            value: true,
            onChanged: (v) {},
          )),
          SliverToBoxAdapter(
              child: SettingsToggleCard(
            title: "Разрешить аналитику",
            value: true,
            onChanged: (v) {},
          )),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          SliverToBoxAdapter(
              child: SettingsActionCard(
            title: "Очистить историю",
            onTap: () {},
            iconData: Icons.delete_sweep_outlined,
            iconColor: theme.primaryColor,
          )),
          SliverToBoxAdapter(
              child: SettingsActionCard(
            title: "Поддержка",
            onTap: () {},
            iconData: Icons.message_outlined,
          )),
        ],
      ),
    );
  }
}

class SettingsActionCard extends StatelessWidget {
  const SettingsActionCard({
    super.key,
    required this.title,
    this.onTap,
    required this.iconData,
    this.iconColor,
  });

  final String title;
  final VoidCallback? onTap;
  final IconData iconData;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
        child: BaseContainer(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  iconData,
                  color: iconColor ?? theme.hintColor.withOpacity(0.3),
                  size: 32,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
