import 'package:flutter/material.dart';
import 'package:quizzer/Setup/config.dart';

class TextStyleWidget extends StatelessWidget {
  final List<int> textStyle;
  final String text;
  final ColorScheme colorScheme;
  final double modifier;

  const TextStyleWidget(
      {required this.textStyle,
      required this.text,
      required this.colorScheme,
      this.modifier = 1.0});

  @override
  Widget build(BuildContext context) {
    Color borderColor =
        textStyle[3] == 2 ? colorScheme.onSurface : colorScheme.outline;

    Color? textColor;
    Color? backgroundColor;
    Border? getBorderBasedOnTextStyle(int textStyleValue) {
      switch (textStyleValue) {
        case 1:
          return Border(
              bottom: BorderSide(
                  color: borderColor, width: 2.0)); // Only bottom border
        case 2:
          return Border.all(
              color: borderColor,
              width: 2.0); // Border color and width for all sides
        default:
          return null; // No border
      }
    }

    switch (textStyle[1]) {
      case 0: // Example case
        textColor = colorScheme.primary;
        backgroundColor = null;
        break;
      case 1: // Another example case
        textColor = colorScheme.secondary;
        backgroundColor = null;
        break;
      case 2: // [tertiary, null]
        textColor = colorScheme.tertiary;
        backgroundColor = null;
        break;
      case 3: // [onSurface, null]
        textColor = colorScheme.onSurface;
        backgroundColor = null;
        break;
      case 4: // [onPrimary, primary]
        textColor = colorScheme.onPrimary;
        backgroundColor = colorScheme.primary;
        break;
      case 5: // [onSecondary, secondary]
        textColor = colorScheme.onSecondary;
        backgroundColor = colorScheme.secondary;
        break;
      case 6: // [onTertiary, tertiary]
        textColor = colorScheme.onTertiary;
        backgroundColor = colorScheme.tertiary;
        break;
      case 7: // [onPrimaryContainer, primaryContainer]
        textColor = colorScheme.onPrimaryContainer;
        backgroundColor = colorScheme.primaryContainer;
        break;
      case 8: // [onSecondaryContainer, secondaryContainer]
        textColor = colorScheme.onSecondaryContainer;
        backgroundColor = colorScheme.secondaryContainer;
        break;
      case 9: // [onTertiaryContainer, tertiaryContainer]
        textColor = colorScheme.onTertiaryContainer;
        backgroundColor = colorScheme.tertiaryContainer;
        break;
      default:
        textColor = colorScheme.onSurface;
        backgroundColor = null;
    }
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor, // Background color for the text
        border: getBorderBasedOnTextStyle(textStyle[2]),
        borderRadius:
            BorderRadius.circular(4.0), // Optional: if you want rounded corners
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            // Expanded 위젯을 사용하여 Text 위젯이 부모의 너비를 채우도록 함
            child: Text(
              text,
              textAlign: TextAlign.left, // Text를 좌측으로 정렬
              style: TextStyle(
                color: textColor,
                fontSize: AppConfig.fontSizes[textStyle[3]] * modifier,
                fontFamily: AppConfig.fontFamilys[textStyle[0]],
                fontWeight: AppConfig.fontWeights[textStyle[3]],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
