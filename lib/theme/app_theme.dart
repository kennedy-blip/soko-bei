import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const emerald = Color(0xFF35D39A);
  static const amber = Color(0xFFFFC46B);
  static ThemeData build(String mode) {
    final light = mode == 'Daylight Stall';
    final high = mode == 'High-Contrast Sun';
    final bg = light ? const Color(0xFFF0F5F1) : (high ? const Color(0xFF050608) : const Color(0xFF101719));
    final surface = light ? const Color(0xFFFFFFFF) : (high ? const Color(0xFF111820) : const Color(0xFF1A2526));
    final fg = light ? const Color(0xFF182522) : Colors.white;
    final scheme = ColorScheme.fromSeed(seedColor: emerald, brightness: light ? Brightness.light : Brightness.dark,
      surface: surface);
    return ThemeData(useMaterial3:true, colorScheme:scheme, scaffoldBackgroundColor:bg,
      textTheme: GoogleFonts.manropeTextTheme(ThemeData(brightness:light?Brightness.light:Brightness.dark).textTheme)
        .apply(bodyColor:fg, displayColor:fg),
      appBarTheme:AppBarTheme(backgroundColor:bg, foregroundColor:fg, elevation:0),
      cardColor:surface, dividerColor:fg.withValues(alpha:.10),
      inputDecorationTheme:InputDecorationTheme(filled:true, fillColor:surface,
        border:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide(color:fg.withValues(alpha:.12))),
        enabledBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:BorderSide(color:fg.withValues(alpha:.12))),
        focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(14),borderSide:const BorderSide(color:emerald))),
      navigationBarTheme:NavigationBarThemeData(backgroundColor:surface, indicatorColor:emerald.withValues(alpha:.18),
        labelTextStyle:WidgetStateProperty.all(TextStyle(fontWeight:FontWeight.w700,color:fg))),
      snackBarTheme:SnackBarThemeData(behavior:SnackBarBehavior.floating,backgroundColor:surface,contentTextStyle:TextStyle(color:fg)));
  }
}
