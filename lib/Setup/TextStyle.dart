import 'package:flutter/material.dart';
import 'package:quizzer/Setup/config.dart';

class TextStyleWidget extends StatelessWidget {
  final List<int> textStyle;
  final String text;
  final ColorScheme colorScheme;
  final double modifier;
  final bool setBorder;

  const TextStyleWidget(
      {required this.textStyle,
      required this.text,
      required this.colorScheme,
      this.modifier = 1.0,
      this.setBorder = false});

  @override
  Widget build(BuildContext context) {
    Color borderColor =
        textStyle[3] == 2 ? colorScheme.onSurface : colorScheme.outline;

    Color? textColor = getTextColor(textStyle, colorScheme);
    Color? backgroundColor = getBackGroundColor(textStyle, colorScheme);
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

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor, // Background color for the text
        border: setBorder ? Border.all(color: borderColor, width: 2.0) : getBorderBasedOnTextStyle(textStyle[2]),
        borderRadius:
            BorderRadius.circular(4.0), // Optional: if you want rounded corners
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            // Expanded 위젯을 사용하여 Text 위젯이 부모의 너비를 채우도록 함
            child: Padding(
              padding: EdgeInsets.all(5.0 * modifier),
              child: Text(
                text,
                textAlign: TextAlign.left, // Text를 좌측으로 정렬
                style: TextStyle(
                  color: textColor,
                  fontSize: AppConfig.fontSizes[textStyle[3]] * modifier,
                  fontFamily: AppConfig.fontFamilys[textStyle[0]],
                  fontWeight: AppConfig.fontWeights[textStyle[3]],
                  overflow: modifier == 0.7
                      ? TextOverflow.ellipsis
                      : TextOverflow.clip,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle getTextFieldTextStyle(List<int> textStyle, ColorScheme colorScheme) {
  Color? textColor = getTextColor(textStyle, colorScheme);
  return TextStyle(
    color: textColor,
    fontSize: AppConfig.fontSizes[textStyle[3]],
    fontFamily: AppConfig.fontFamilys[textStyle[0]],
    fontWeight: AppConfig.fontWeights[textStyle[3]],
  );
}

Color? getBackGroundColor(List<int> textStyle, ColorScheme colorScheme)
{
  Color? backgroundColor;
      switch (textStyle[1]) {
      case 0: // Example case
        backgroundColor = null;
        break;
      case 1: // Another example case
        backgroundColor = null;
        break;
      case 2: // [tertiary, null]
        backgroundColor = null;
        break;
      case 3: // [onSurface, null]
        backgroundColor = null;
        break;
      case 4: // [onPrimary, primary]
        backgroundColor = colorScheme.primary;
        break;
      case 5: // [onSecondary, secondary]
        backgroundColor = colorScheme.secondary;
        break;
      case 6: // [onTertiary, tertiary]
        backgroundColor = colorScheme.tertiary;
        break;
      case 7: // [onPrimaryContainer, primaryContainer]
        backgroundColor = colorScheme.primaryContainer;
        break;
      case 8: // [onSecondaryContainer, secondaryContainer]
        backgroundColor = colorScheme.secondaryContainer;
        break;
      case 9: // [onTertiaryContainer, tertiaryContainer]
        backgroundColor = colorScheme.tertiaryContainer;
        break;
      default:
        backgroundColor = null;
    }
  return backgroundColor;
}

Color getTextColor(List<int> textStyle, ColorScheme colorScheme){

  Color textColor;
    switch (textStyle[1]) {
      case 0: // Example case
        textColor = colorScheme.primary;
        break;
      case 1: // Another example case
        textColor = colorScheme.secondary;
        break;
      case 2: // [tertiary, null]
        textColor = colorScheme.tertiary;
        break;
      case 3: // [onSurface, null]
        textColor = colorScheme.onSurface;
        break;
      case 4: // [onPrimary, primary]
        textColor = colorScheme.onPrimary;
        break;
      case 5: // [onSecondary, secondary]
        textColor = colorScheme.onSecondary;
        break;
      case 6: // [onTertiary, tertiary]
        textColor = colorScheme.onTertiary;
        break;
      case 7: // [onPrimaryContainer, primaryContainer]
        textColor = colorScheme.onPrimaryContainer;
        break;
      case 8: // [onSecondaryContainer, secondaryContainer]
        textColor = colorScheme.onSecondaryContainer;
        break;
      case 9: // [onTertiaryContainer, tertiaryContainer]
        textColor = colorScheme.onTertiaryContainer;
        break;
      default:
        textColor = colorScheme.onSurface;
    }
  return textColor;

}