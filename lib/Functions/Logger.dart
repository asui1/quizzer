import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class Logger {
  static final bool isRelease = false;

  static void log(dynamic message) {
    if (!isRelease) {
      final stackTrace = StackTrace.current;
      final stackTraceLines = stackTrace.toString().split("\n");

      String callerDetails = "";
      for (var line in stackTraceLines) {
        // `<asynchronous suspension>`을 건너뛰고 실제 호출 세부 정보를 찾습니다.
        if (!line.contains('<asynchronous suspension>') &&
            line.contains('Logger.dart') == false) {
          callerDetails = line.trim();
          break; // 첫 번째 유효한 호출 세부 정보를 찾으면 반복을 중단합니다.
        }
      }

      developer.log('$message\nCalled from: $callerDetails', name: 'Logger');
    }
  }

  static void logFullContent(dynamic content) {
    const int printLength = 1000; // Adjust this value as needed
    String contentString = content.toString();
    if (contentString.length <= printLength) {
    } else {
      // If content is too long, split it into parts and log each part
      List<String> parts = [];
      for (int i = 0; i < contentString.length; i += printLength) {
        parts.add(contentString.substring(
            i,
            i + printLength > contentString.length
                ? contentString.length
                : i + printLength));
      }
      for (String part in parts) {
        Logger.log(part);
      }
    }
  }
}
