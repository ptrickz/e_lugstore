import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final IconData icondata;
  final TextEditingController controller;
  const InputField({
    super.key,
    required this.labelText,
    required this.icondata,
    required this.controller,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 300,
      height: 50,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            borderRadius: BorderRadius.circular(8),
          ),
          labelText: widget.labelText,
          hintText: "Enter your ${widget.labelText}",
          prefixIcon: Icon(widget.icondata),
        ),
        controller: widget.controller,
      ),
    );
  }
}
