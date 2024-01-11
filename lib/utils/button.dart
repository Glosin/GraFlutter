import 'package:flutter/material.dart';
import 'colors.dart';

class ButtonContainer extends StatelessWidget {
  final child;
  final width;
  final onTap;
  final color;
  final padding;

  const ButtonContainer({
    super.key,
    required this.onTap,
    required this.child,
    this.color,
    this.width,
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: (width != null) ? width : double.infinity,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (color != null) ? color : AppColors.blue,
        ),
        child: Padding(
          padding: EdgeInsets.all((padding != null) ? padding : 10),
          child: child,
        ),
      ),
    );
  }
}
