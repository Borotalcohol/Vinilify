import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String text;
  final Function()? onPressed;

  const Button({super.key, required this.text, required this.onPressed});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return const Color(0x33272727);
            } else {
              return Theme.of(context).primaryColor;
            }
          }),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 15.0),
          ),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  10.0,
                ),
              ),
            ),
          ),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
