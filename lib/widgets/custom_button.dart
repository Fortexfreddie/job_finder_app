import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double width;
  // final double height;
  final double v_padding;

  const CustomButton({
    super.key,
    required this.text,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.width = double.infinity,
    // this.height = 100,
    this.v_padding = 15,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: widget.height,
      width: widget.width,
      child: ElevatedButton.icon(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          // side: BorderSide(color: Colors.grey.shade300),
          backgroundColor: widget.backgroundColor,
          padding: EdgeInsets.symmetric(vertical: widget.v_padding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: widget.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : widget.icon != null
            ? Icon(widget.icon, color: widget.textColor)
            : Container(),
        label: Text(
          widget.text,
          style: TextStyle(color: widget.textColor, fontSize: 16),
        ),
      ),
    );
  }
}
