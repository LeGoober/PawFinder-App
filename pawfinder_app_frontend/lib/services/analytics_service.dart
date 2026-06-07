import 'package:flutter/foundation.dart';

/// Lightweight analytics façade.
///
/// Currently logs all events to the debug console. Replace the
/// implementation when a real analytics provider (Firebase, Mixpanel,
/// etc.) is integrated.
class AnalyticsService {
  /// Log a named event with optional parameters.
  Future<void> logEvent(String name, Map<String, dynamic>? parameters) async {
    debugPrint('[Analytics] $name ${parameters ?? ""}');
  }

  /// Log a screen-view event.
  Future<void> logScreenView(String screenName) async {
    await logEvent('screen_view', <String, dynamic>{
      'screen_name': screenName,
    });
  }
}
