import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sl/shared/typography.dart';

import '../../shared/app_colors.dart';
import '../../shared/font_helper.dart';
import '../../shared/utils/hex_color.dart';

class MyTextField extends StatefulWidget {
  final TextStyle? textStyle;
  final TextEditingController? controller;
  final bool isPass, isReadOnly, autoFocus;
  final String hintText;
  final TextStyle? hindStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextInputType textInputType;
  final VoidCallback? onTap;
  final bool isValidate;
  final String? Function(String?)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showLabel;
  final Function(String)? onChanged;
  final bool showCounter;
  final String? helperText;
  final TextStyle? helperStyle;
  final Widget? helperIcon;
  final FloatingLabelBehavior floatingLabelBehavior;
  final int? maxLines;
  const MyTextField({
    super.key,
    this.textStyle,
    this.controller,
    this.isPass = false,
    this.isReadOnly = false,
    this.autoFocus = false,
    required this.hintText,
    this.hindStyle,
    this.labelText,
    this.labelStyle,
    this.textInputType = TextInputType.text,
    this.onTap,
    this.isValidate = true,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.showLabel = true,
    this.onChanged,
    this.showCounter = false,
    this.helperText,
    this.helperStyle,
    this.helperIcon,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.maxLines,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isObserver = false;
  int textCount = 0;

  final OutlineInputBorder inputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
    borderRadius: const BorderRadius.all(Radius.circular(8)),
  );

  final OutlineInputBorder errorBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.errorColor),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      // <- Here
      data: Theme.of(context).copyWith(
        // <- Here
        splashColor: Colors.transparent, // <- Here
        highlightColor: Colors.transparent, // <- Here
        hoverColor: Colors.transparent, // <- Here
        focusColor: Colors.transparent, // <- Here
      ),
      child: TextFormField(
        controller: widget.controller,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
          textCount = value.length;
          setState(() {});
        },
        validator: widget.isValidate ? widget.validator : null,
        style: widget.textStyle ?? AppTypography.bodySmall(),
        readOnly: widget.isReadOnly,
        autofocus: widget.autoFocus,
        onTap: widget.onTap,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        cursorColor: const Color(0xFF212B36),
        maxLines: widget.maxLines ?? 1,
        keyboardType: widget.maxLines != null
            ? TextInputType.multiline
            : widget.textInputType,
        decoration: InputDecoration(
          counter: const Offstage(),
          isDense: true,
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          labelText: widget.labelText ?? widget.hintText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintStyle:
              widget.hindStyle ??
              AppTypography.bodySmall(color: Colors.black54),
          labelStyle:
              widget.labelStyle ??
              AppTypography.bodySmall(color: Colors.black87),
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          errorBorder: errorBorder,
          errorStyle: FontHelper.ts12w400(color: AppColors.errorColor),
          suffixIcon: widget.isPass
              ? IconButton(
                  icon: isObserver
                      ? const Icon(Icons.visibility_outlined, size: 25)
                      : const Icon(Icons.visibility_off_outlined, size: 25),
                  onPressed: () => setState(() => isObserver = !isObserver),
                )
              : widget.suffixIcon,
          filled: true,
          fillColor: Colors.white,
        ),
        obscureText: widget.isPass && !isObserver,
      ),
    );
  }
}

class MyTextFieldOutline extends StatefulWidget {
  final TextStyle? textStyle;
  final TextEditingController? controller;
  final bool isPass, isReadOnly, autoFocus;
  final String hintText;
  final TextStyle? hindStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextInputType textInputType;
  final VoidCallback? onTap;
  final bool isValidate;
  final String? Function(String?)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showLabel;
  final Function(String)? onChanged;
  final bool showCounter;
  final String? helperText;
  final TextStyle? helperStyle;
  final Widget? helperIcon;
  const MyTextFieldOutline({
    Key? key,
    this.textStyle,
    this.controller,
    this.isPass = false,
    this.isReadOnly = false,
    this.autoFocus = false,
    required this.hintText,
    this.hindStyle,
    this.labelText,
    this.labelStyle,
    this.textInputType = TextInputType.text,
    this.onTap,
    this.isValidate = true,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.showLabel = true,
    this.onChanged,
    this.showCounter = false,
    this.helperText,
    this.helperStyle,
    this.helperIcon,
  }) : super(key: key);

  @override
  State<MyTextFieldOutline> createState() => _MyTextFieldOutlineState();
}

class _MyTextFieldOutlineState extends State<MyTextFieldOutline> {
  bool isObserver = false;
  int textCount = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      // <- Here
      data: Theme.of(context).copyWith(
        // <- Here
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
      child: TextFormField(
        controller: widget.controller,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
          textCount = value.length;
          setState(() {});
        },
        validator: widget.isValidate ? widget.validator : null,
        style: widget.textStyle ?? FontHelper.ts14w700(),
        readOnly: widget.isReadOnly,
        autofocus: widget.autoFocus,
        onTap: widget.onTap,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        cursorColor: Color(0xFF212B36),
        decoration: InputDecoration(
          counter: const Offstage(),
          isDense: true,
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          hintStyle: widget.hindStyle ?? FontHelper.ts18w400(),
          labelText: (widget.labelText ?? widget.hintText),
          labelStyle: widget.labelStyle ?? FontHelper.ts18w400(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: HexColor("#212B36"), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.errorColor),
          ),
          // contentPadding: const EdgeInsets.all(16),
          // contentPadding:
          //     const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          // // errorText: null,
          // errorStyle: FontHelper.ts12(color: ColorConstants.errorColor),
          errorText: null,
          errorStyle: const TextStyle(fontSize: 0),
          suffixIcon: widget.isPass
              ? IconButton(
                  icon: isObserver
                      ? const Icon(Icons.visibility_outlined, size: 25)
                      : const Icon(Icons.visibility_off_outlined, size: 25),
                  onPressed: () => setState(() => isObserver = !isObserver),
                )
              : widget.suffixIcon,
        ),
        keyboardType: widget.textInputType,
        obscureText: widget.isPass && !isObserver,
      ),
    );
  }
}
