import 'package:flutter/material.dart';

class InputFieldBlock extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final String placeholder;
  final String label;
  final int numOfLines;
  final Function(String?)? onChanged;

  const InputFieldBlock({
    super.key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.focusNode,
    this.validator,
    this.numOfLines = 1,
    this.onChanged,
  });

  @override
  State<InputFieldBlock> createState() => _InputFieldBlockState();
}

class _InputFieldBlockState extends State<InputFieldBlock> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.label,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 10.0),
      TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        validator: widget.validator,
        maxLines: widget.numOfLines,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFFCECECE),
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xFFCECECE), // Border color
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 171, 171, 171), // Border color
              width: 1.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          hintText: widget.placeholder,
          hintStyle: const TextStyle(
            color: Color(0xFF8D8D8D),
            fontSize: 16.0,
          ),
        ),
      )
    ]);
  }
}
