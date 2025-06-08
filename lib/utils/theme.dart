import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color heroTextColor;
  final Color promoTextColor;

  const CustomColors({
    required this.heroTextColor,
    required this.promoTextColor,
  });

  @override
  CustomColors copyWith({Color? heroTextColor, Color? promoTextColor}) {
    return CustomColors(
      heroTextColor: heroTextColor ?? this.heroTextColor,
      promoTextColor: promoTextColor ?? this.promoTextColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      heroTextColor: Color.lerp(heroTextColor, other.heroTextColor, t)!,
      promoTextColor: Color.lerp(promoTextColor, other.promoTextColor, t)!,
    );
  }
}
