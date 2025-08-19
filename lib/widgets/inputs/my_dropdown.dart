import 'package:flutter/material.dart';

import '../../shared/app_colors.dart';
import '../../shared/typography.dart';

class MyDropDown extends StatelessWidget {
  final dynamic value;
  final Color? dropdownBackgroundColor, dropdownIconColor;
  final ValueChanged<dynamic>? onChanged;
  final List<DropdownMenuItem<dynamic>>? items;
  final String? hintText;

  const MyDropDown({
    super.key,
    this.value,
    this.onChanged,
    this.items,
    this.hintText,
    this.dropdownBackgroundColor,
    this.dropdownIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding:
      //     const EdgeInsets.symmetric(horizontal: ksWidgetHorizontalSpace15),
      decoration: BoxDecoration(color: dropdownBackgroundColor),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          value: value,
          selectedItemBuilder: (BuildContext context) {
            return items!.map<Widget>((DropdownMenuItem<dynamic> item) {
              return Text(
                item.value.toString(),
                style: AppTypography.bodyMedium(color: Colors.black),
              );
            }).toList();
          },
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: dropdownIconColor ?? Colors.grey,
            size: 30,
          ),
          isExpanded: true,
          style: AppTypography.labelLarge(color: Colors.black),
          onChanged: onChanged,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.all(0),
            counter: const Offstage(),
            isDense: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: AppTypography.bodyMedium(),
            labelStyle: AppTypography.bodyMedium(),
            hintText: hintText ?? '',
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.errorColor),
            ),
            errorStyle: AppTypography.bodySmall(color: AppColors.errorColor),
            filled: true,
            fillColor: Colors.white,
          ),
          hint: Text(
            hintText ?? '',
            style: AppTypography.labelLarge(color: Colors.grey),
          ),
          items: items,
        ),
      ),
    );
  }
}
