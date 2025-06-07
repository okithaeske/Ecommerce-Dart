import 'package:flutter/material.dart';

Widget buildHeroImage(String imagePath, Color accent, {double height = 90}) {
  return Center(
    child: Hero(
      tag: imagePath,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: accent.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.07),
              blurRadius: 13,
              spreadRadius: 1,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(imagePath, height: height, fit: BoxFit.contain),
        ),
      ),
    ),
  );
}
