import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pencil/constants.dart';
import 'package:pencil/data/settings/settings_provider.dart';
import 'package:provider/provider.dart';

class BooleanTile extends StatelessWidget {
  const BooleanTile({super.key, required this.icon, required this.title, required this.value, required this.onChanged});

  final Widget icon;
  final String title;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SwitchListTile(
        secondary: icon,
        value: value,
        onChanged: (value) {
          setBoolean(context, value);
        },
        title: Text(title, style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)));
  }

  Future<void> setBoolean(BuildContext context, bool value) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    onChanged(value);
    await settings.save();
  }
}

class EnumTile<T> extends StatefulWidget {
  const EnumTile(
      {super.key, required this.icon, required this.title, required this.value, required this.mapping, required this.onChanged});

  final Widget icon;
  final String title;
  final T value;
  final Map<T, String> mapping;
  final void Function(T) onChanged;

  @override
  State<EnumTile<T>> createState() => _EnumTileState();
}

class _EnumTileState<T> extends State<EnumTile<T>> {
  final Map<String, T> _reverseMapping = {};

  @override
  void initState() {
    super.initState();
    for (MapEntry<T, String> entry in widget.mapping.entries) {
      _reverseMapping[entry.value] = entry.key;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SettingsProvider settings = Provider.of<SettingsProvider>(context);

    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
            color: Colors.transparent,
            child: PopupMenuButton<T>(
                onSelected: (value) {
                  widget.onChanged(value);
                  settings.save();
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tooltip: '',
                child: ListTile(
                    leading: widget.icon,
                    title: Text(widget.title, style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
                    subtitle: Text(widget.mapping[widget.value]!,
                        style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                itemBuilder: (context) => [
                      for (MapEntry<T, String> entry in widget.mapping.entries)
                        PopupMenuItem(value: entry.key, child: Text(entry.value))
                    ])));
  }
}

class TextInputTile extends StatefulWidget {
  TextInputTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.dialogTitle,
      required this.value,
      required this.onChanged,
      String? Function(String)? isValid})
      : this.isValid = isValid ?? ((_) => null);

  final Widget icon;
  final String title;
  final String dialogTitle;
  final String value;
  final void Function(String) onChanged;
  final String? Function(String) isValid;

  @override
  State<TextInputTile> createState() => _TextInputTileState();
}

class _TextInputTileState extends State<TextInputTile> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListTile(
        leading: widget.icon,
        onTap: () {
          setText();
        },
        title: Text(widget.title, style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
        subtitle: Text(widget.value, style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)));
  }

  Future<void> setText() async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
        context: kBaseNavigatorKey.currentContext!,
        builder: (context) {
          TextEditingController controller = TextEditingController(text: widget.value);
          String? error;
          return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
                      title: Text(widget.dialogTitle),
                      content: TextField(
                        decoration: InputDecoration(labelText: widget.title, errorText: error),
                        controller: controller,
                      ),
                      actions: [
                        TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              setState(() {
                                error = widget.isValid(controller.text);
                              });
                              if (error == null) {
                                widget.onChanged(controller.text);
                                settings.save();
                                Navigator.pop(context);
                              }
                            })
                      ]));
        });
  }
}

class DirectoryTile extends StatelessWidget {
  const DirectoryTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.dialogTitle,
      required this.subtitle,
      required this.onChanged});

  final Widget icon;
  final String title;
  final String dialogTitle;
  final String subtitle;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListTile(
        leading: icon,
        onTap: () {
          setDirectory(context);
        },
        title: Text(title, style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400)),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.secondary)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)));
  }

  Future<void> setDirectory(BuildContext context) async {
    SettingsProvider settings = Provider.of<SettingsProvider>(context, listen: false);
    String? directory = await FilePicker.platform.getDirectoryPath(dialogTitle: dialogTitle, lockParentWindow: true);
    if (directory != null) {
      onChanged(directory);
      await settings.save();
    }
  }
}
