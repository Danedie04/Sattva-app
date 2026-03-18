import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand palette
  static const Color bg         = Color(0xFF08090E);
  static const Color surface    = Color(0xFF0F1119);
  static const Color card       = Color(0xFF13161F);
  static const Color border     = Color(0xFF1E2130);
  static const Color accent     = Color(0xFFB57BFF);   // soft violet
  static const Color accentGlow = Color(0xFF7C3AED);   // deep purple
  static const Color gold       = Color(0xFFE8C97E);   // saffron gold
  static const Color textPrimary   = Color(0xFFF0EEF8);
  static const Color textSecondary = Color(0xFF7A7D99);
  static const Color textMuted     = Color(0xFF3D4060);

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    primaryColor: accent,
    colorScheme: ColorScheme.dark(
      primary: accent,
      secondary: gold,
      surface: surface,
      onPrimary: Colors.white,
      onSurface: textPrimary,
    ),
    textTheme: GoogleFonts.dmSansTextTheme().copyWith(
      displayLarge: GoogleFonts.cormorantGaramond(
        color: textPrimary, fontSize: 48, fontWeight: FontWeight.w600,
        letterSpacing: -1,
      ),
      headlineMedium: GoogleFonts.cormorantGaramond(
        color: textPrimary, fontSize: 28, fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.dmSans(
        color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      titleMedium: GoogleFonts.dmSans(
        color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.dmSans(
        color: textPrimary, fontSize: 15,
      ),
      bodyMedium: GoogleFonts.dmSans(
        color: textSecondary, fontSize: 13,
      ),
      labelSmall: GoogleFonts.dmMono(
        color: textMuted, fontSize: 11, letterSpacing: 1.5,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cormorantGaramond(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 3,
      ),
      iconTheme: const IconThemeData(color: textSecondary),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? accent : Colors.transparent),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: accent, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: accentGlow.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w500,
            color: textSecondary),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) =>
          IconThemeData(
            color: states.contains(WidgetState.selected) ? accent : textMuted,
            size: 22,
          )),
    ),
    dividerTheme: const DividerThemeData(color: border, thickness: 1),
  );
}
