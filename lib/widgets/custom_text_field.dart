import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  String? hintText;
  Function(String)? onChanged;
  bool obscureText ;
  CustomFormTextField({required this.hintText, this.onChanged, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      validator: (data)
      {
        if(data!.isEmpty)
        {
          return "field is required";
        }
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
