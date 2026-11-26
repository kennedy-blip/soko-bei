import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.margin, this.onTap});
  final Widget child; final EdgeInsets padding; final EdgeInsets? margin; final VoidCallback? onTap;
  @override Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(borderRadius:BorderRadius.circular(22),child:BackdropFilter(
      filter:ImageFilter.blur(sigmaX:16,sigmaY:16),
      child:Material(color:theme.cardColor.withValues(alpha:.78),
        child:InkWell(onTap:onTap,child:Container(margin:margin,padding:padding,
          decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),
            border:Border.all(color:theme.colorScheme.onSurface.withValues(alpha:.09))),
          child:child)))));
  }
}
