import 'package:flutter/foundation.dart';

void debugLog(Object? message) {
  if (kDebugMode && message != null) {
    print(message.toString());
  }
}