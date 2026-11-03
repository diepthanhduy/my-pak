import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/services/shared_pdf_source.dart';

/// Android: `MainActivity` copies a PDF received via VIEW / SEND into the
/// cache and hands over its path. Other platforms: nothing is shared yet.
@LazySingleton(as: SharedPdfSource)
class MethodChannelSharedPdfSource implements SharedPdfSource {
  MethodChannelSharedPdfSource() {
    if (Platform.isAndroid) {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'onPdfShared' && call.arguments is String) {
          _shared.add(call.arguments as String);
        }
      });
    }
  }

  static const _channel = MethodChannel(
    'com.diepthanhduy.assistant_pak/shared_pdf',
  );

  final _shared = StreamController<String>.broadcast();

  @override
  Future<String?> takeInitialPdf() async {
    if (!Platform.isAndroid) return null;
    return _channel.invokeMethod<String>('takeInitialPdf');
  }

  @override
  Stream<String> get sharedPdfs => _shared.stream;
}
