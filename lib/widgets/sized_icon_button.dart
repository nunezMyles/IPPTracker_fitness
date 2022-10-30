import 'package:flutter/material.dart';

class SizedIconButton extends StatelessWidget {
  const SizedIconButton(
      {Key? key,
        required this.width,
        required this.icon,
        required this.onPressed})
      : super(key: key);

  ///[width] sets the size of the icon
  final double width;

  ///[icon] sets the icon
  final IconData icon;

  /// [onPressed] is the callback
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextButton(
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}