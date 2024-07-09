import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class Logger {
  static final bool isRelease = kReleaseMode;

  static void logError(String message) {
    if (!isRelease) {
      developer.log(message, name: 'asuiQuizzer');
    }
  }
}