import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final IconData icondata;
  const InputField({
    super.key,
    required this.labelText,
    required this.icondata,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
      )),
    );
  }
}
