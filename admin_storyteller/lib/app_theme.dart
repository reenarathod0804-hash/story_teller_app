import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Palette ──────────────────────────────────────────────────────────────
  static const Color bg        = Color(0xFF0D0F14);
  static const Color surface   = Color(0xFF161A23);
  static const Color card      = Color(0xFF1E2330);
  static const Color border    = Color(0xFF2A3045);
  static const Color accent    = Color(0xFF6C63FF);
  static const Color accentAlt = Color(0xFF8B5CF6);
  static const Color success   = Color(0xFF10B981);
  static const Color danger    = Color(0xFFEF4444);
  static const Color textPrimary   = Color(0xFFEAEBF0);
  static const Color textSecondary = Color(0xFF8890A4);
  static const Color sidebar   = Color(0xFF13161F);

  // ── Gradient ──────────────────────────────────────────────────────────────
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentAlt],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Text Styles ───────────────────────────────────────────────────────────
  static TextStyle heading(double size) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.3,
      );

  static TextStyle body(double size, {Color? color}) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color ?? textPrimary,
      );

  static TextStyle label(double size) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.4,
      );

  // ── Shared Decoration ─────────────────────────────────────────────────────
  static BoxDecoration cardDecoration({double radius = 16}) => BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static InputDecoration inputDecoration(String hint, {IconData? icon}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        filled: true,
        fillColor: bg,
        prefixIcon: icon != null
            ? Icon(icon, color: textSecondary, size: 18)
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
      );

  // ── ThemeData ─────────────────────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: accent,
          surface: surface,
          onSurface: textPrimary,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: surface,
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          iconTheme: const IconThemeData(color: textPrimary),
          surfaceTintColor: Colors.transparent,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: border),
          ),
        ),
      );
}
