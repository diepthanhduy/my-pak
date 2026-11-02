import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/services/phone_launcher.dart';

/// Launches the system dialer / SMS composer through `tel:` and `sms:` URLs.
///
/// Android direct calls (ACTION_CALL) and direct SMS will replace this later.
@LazySingleton(as: PhoneLauncher)
class UrlPhoneLauncher implements PhoneLauncher {
  @override
  Future<bool> startCall(String phone) =>
      _launch(Uri(scheme: 'tel', path: phone));

  @override
  Future<bool> openSms(String phone, String body) {
    // iOS expects `sms:<number>&body=`, Android `sms:<number>?body=`.
    final separator = defaultTargetPlatform == TargetPlatform.iOS ? '&' : '?';
    return _launch(
      Uri.parse('sms:$phone${separator}body=${Uri.encodeComponent(body)}'),
    );
  }

  Future<bool> _launch(Uri uri) async {
    try {
      return await launchUrl(uri);
    } on PlatformException {
      return false;
    }
  }
}
