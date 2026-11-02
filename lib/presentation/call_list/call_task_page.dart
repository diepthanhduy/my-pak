import 'package:flutter/material.dart';

import '../common/app_strings.dart';
import '../common/stub_page.dart';

/// Stub: call task detail + contact history comes in a later step.
class CallTaskPage extends StatelessWidget {
  const CallTaskPage({super.key, required this.callTaskId});

  final int? callTaskId;

  @override
  Widget build(BuildContext context) =>
      const StubPage(title: AppStrings.callTaskDetail);
}
