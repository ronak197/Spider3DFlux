import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle myTextStyle() {
  return GoogleFonts.heebo(fontWeight: FontWeight.w600);
}

TextTheme myTextTheme() {
  return TextTheme(
    bodyText2: myTextStyle(),
    bodyText1: myTextStyle(),
    button: myTextStyle(),
    caption: myTextStyle(),
    headline4: myTextStyle(),
    headline3: myTextStyle(),
    headline2: myTextStyle(),
    headline1: myTextStyle(),
    headline5: myTextStyle(),
    overline: myTextStyle(),
    subtitle1: myTextStyle(),
    subtitle2: myTextStyle(),
    headline6: myTextStyle(),
  );
}

/// Google fonts constant setting: https://fonts.google.com/
TextTheme kTextTheme(theme, String? language) {
  switch (language) {
    case 'vi':
      return GoogleFonts.ralewayTextTheme(theme);
    case 'ar':
      return GoogleFonts.ralewayTextTheme(theme);
    default:
      // return GoogleFonts.ralewayTextTheme(theme);
      return GoogleFonts.heeboTextTheme(theme);
    // return myTextTheme();
  }
}

TextTheme kHeadlineTheme(theme, [language = 'en']) {
  switch (language) {
    case 'vi':
      return GoogleFonts.ralewayTextTheme(theme);
    case 'ar':
      return GoogleFonts.ralewayTextTheme(theme);
    default:
      // return GoogleFonts.ralewayTextTheme(theme);
      return GoogleFonts.heeboTextTheme(theme);
    // return myTextTheme();
  }
}
