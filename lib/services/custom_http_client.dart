import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

class CustomHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final locale = PlatformDispatcher.instance.locale.languageCode;

    request.headers.addAll({
      'Accept-Language': locale,
      'Content-Type': 'application/json',
      // 'Accept-Language': "fr ",
    });

    return _inner.send(request);
  }
}
