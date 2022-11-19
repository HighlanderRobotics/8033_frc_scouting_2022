import 'package:flutter/material.dart';

AppBar scoutingAppBar(String title,
    {List<Widget>? actions, bool hideBackButton = false}) {
  return AppBar(
    title: Text(
      title,
    ),
    actions: actions,
  );
}
