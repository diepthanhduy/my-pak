import 'package:flutter/material.dart';

import '../common/app_strings.dart';
import '../common/stub_page.dart';

/// Stub: SMS template, retry limit and clinic info come in a later step.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const StubPage(title: AppStrings.settings);
}
