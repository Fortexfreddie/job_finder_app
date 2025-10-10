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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              // labelText: widget.label,
              // labelStyle: const TextStyle(
              //   fontSize: 16,
              //   color: Colors.grey,
              // ),
              hintText: widget.value,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.black.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: widget.icon != null
                  ? Icon(widget.icon, color: Colors.blue)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
        ),
    );
  }
}