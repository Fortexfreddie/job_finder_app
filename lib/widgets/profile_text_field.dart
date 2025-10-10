import 'package:flutter/material.dart';

class ProfileTextField extends StatefulWidget {

  final String label;
  final String value;
  final IconData? icon;

  const ProfileTextField({
    required this.label,
    required this.value,
    this.icon,
    super.key
  });

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.only(bottom: 14.0),
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            hintText: widget.value,
            hintStyle: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: widget.icon != null ? Icon(widget.icon, color: Colors.blue) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
    );
  }
}