import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool? isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword!,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
