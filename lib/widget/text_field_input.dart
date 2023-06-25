import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditController;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPass;

  const TextFieldInput({
    super.key,
    required this.textEditController,
    required this.hintText,
    required this.keyboardType,
    this.isPass = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(7),
      ),
      keyboardType: keyboardType,
      obscureText: isPass,
    );
  }
}
