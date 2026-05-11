import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onTap,
    required this.buttonText,
  });

  final void Function() onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      height: 56,
      child: InkWell(
        splashColor: Colors.blueGrey,
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.85),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
