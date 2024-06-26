import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String title;
  final bool? selected;
  final IconData icon;
  final Function onTap;

  const DrawerListTile({
    super.key,
    required this.title,
    this.selected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.transparent,
      selected: selected ?? false,
      leading: Icon(icon),
      title: Text(title, style: const TextStyle()),
      onTap: () => onTap(),
    );
  }
}
