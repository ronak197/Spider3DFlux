import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle myTextStyle() {
  return GoogleFonts.heebo(fontWeight: FontWeight.w600);
}

TextTheme myTextTheme() {
  return TextTheme(
    body1: myTextStyle(),
    body2: myTextStyle(),
    button: myTextStyle(),
    caption: myTextStyle(),
    display1: myTextStyle(),
    display2: myTextStyle(),
    display3: myTextStyle(),
    display4: myTextStyle(),
    headline: myTextStyle(),
    overline: myTextStyle(),
    subhead: myTextStyle(),
    subtitle: myTextStyle(),
    title: myTextStyle(),
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
      // return GoogleFonts.heeboTextTheme(theme);
      return myTextTheme();
  }
}
