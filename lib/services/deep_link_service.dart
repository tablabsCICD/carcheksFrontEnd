import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../provider/auth_provider.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  void init(BuildContext context, AuthProvider auth) {
    // Cold start
    _appLinks.getInitialAppLink().then((uri) {
      if (uri != null) {
        _handleUri(context, uri, auth);
      }
    });

    // App in background / foreground
    _sub = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(context, uri, auth);
    });
  }

  void dispose() {
    _sub?.cancel();
  }

  void _handleUri(BuildContext context, Uri uri, AuthProvider auth) {
    debugPrint("🔗 Deep link received: $uri");

    final segments = uri.pathSegments;
    if (segments.isEmpty) return;

    // 🔐 Auth guard
    if (auth.user == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    switch (segments.first) {
      case 'login':
        Navigator.pushNamed(context, '/login');
        break;

      case 'register':
        Navigator.pushNamed(context, '/registerCustomer');

        break;

      case 'garage':
        if (segments.length > 1) {
          Navigator.pushNamed(
            context,
            '/garageDetails',
            arguments: segments[1],
          );
        }
        break;

      case 'appointment':
        if (segments.length > 1) {
          Navigator.pushNamed(
            context,
            '/appointmentDetails',
            arguments: segments[1],
          );
        }
        break;

      default:
        debugPrint("⚠️ Unknown deep link");
    }
  }
}
