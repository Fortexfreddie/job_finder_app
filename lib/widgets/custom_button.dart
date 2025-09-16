import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        icon: widget.icon != null ? Icon(widget.icon, color: widget.textColor) : Container(),
        label: Text(
          widget.text,
          style: TextStyle(color: widget.textColor, fontSize: 16),
        ),
      ),
    );
  }
}
