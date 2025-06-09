import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color promoTextColor;
  final Color heroTextColor;

  const CustomColors({
    required this.promoTextColor,
    required this.heroTextColor,
  });

  @override
  CustomColors copyWith({
    Color? promoTextColor,
    Color? heroTextColor,
  }) {
    return CustomColors(
      promoTextColor: promoTextColor ?? this.promoTextColor,
      heroTextColor: heroTextColor ?? this.heroTextColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      promoTextColor: Color.lerp(promoTextColor, other.promoTextColor, t)!,
      heroTextColor: Color.lerp(heroTextColor, other.heroTextColor, t)!,
    );
  }
}
