import 'package:flutter/material.dart';

class ModernTextFormField extends TextFormField {
  ModernTextFormField({
    Key? key,
    String? initialValue,
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool? autofocus,
    bool? obscureText,
    bool? autocorrect,
    // bool? maxLengthEnforcement,
    int? maxLines,
    int? minLines,
    bool? enabled,
    void Function(String?)? onChanged,
    void Function(String?)? onSaved,
    // EdgeInsets? padding,
    InputDecoration? decoration,
  }) : super(
          key: key,
          initialValue: initialValue,
          style: style,
          textAlign: textAlign ?? TextAlign.center,
          textDirection: textDirection,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofocus: autofocus ?? false,
          obscureText: obscureText ?? false,
          autocorrect: autocorrect ?? false,
          // maxLengthEnforcement: maxLengthEnforcement,
          maxLines: maxLines,
          minLines: minLines,
          enabled: enabled,
          onChanged: onChanged,
          onSaved: onSaved,
          // padding: padding,
          decoration: decoration ??
              InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
        );
}
