import 'package:flutter/material.dart';

import 'app_strings.dart';

/// Placeholder for screens built in later steps.
class StubPage extends StatelessWidget {
  const StubPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: const Center(child: Text(AppStrings.comingSoon)),
  );
}
