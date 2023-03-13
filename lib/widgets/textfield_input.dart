import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final TextInputType textInputType;
  final int maxlines;
  final String initialText;

  const TextFieldInput(
      {super.key,
      required this.controller,
      required this.isPassword,
      required this.hintText,
      required this.textInputType,
      this.initialText = '',
      this.maxlines = 1});

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          hintText: widget.hintText,
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          contentPadding: const EdgeInsets.all(8)),
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword,
      maxLines: widget.maxlines,
    );
  }
}
