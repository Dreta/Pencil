import 'package:flutter/material.dart';

class SettingsAbout extends StatelessWidget {
  const SettingsAbout({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(margin: const EdgeInsets.only(bottom: 16), child: const Icon(Icons.circle, size: 64)),
      Container(margin: const EdgeInsets.only(bottom: 8), child: Text('Pencil', style: theme.textTheme.headlineMedium)),
      Text('Pencil is a modern Material Design Minecraft launcher.', style: theme.textTheme.bodyMedium),
      Text('Pencil is not endorsed by or affiliated with Microsoft, Mojang or Minecraft.', style: theme.textTheme.bodyMedium)
    ]));
  }
}
