import 'package:flutter/material.dart';

class GenerateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GenerateButton({required this.onPressed, super.key, TextStyle? style});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor:
            const Color.fromARGB(255, 0, 0, 0), // Цвет текста кнопки
        backgroundColor:
            const Color.fromARGB(255, 84, 255, 84), // Цвет фона кнопки
      ),
      child: const Text('Generate'),
    );
  }
}
