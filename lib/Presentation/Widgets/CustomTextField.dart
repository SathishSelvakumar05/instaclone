import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

//custom text field
class CustomTextField extends StatelessWidget {
  final String placeHolder;
  final GlobalKey<FormFieldState>? fieldKey;
  final String name;
  final String? labelName;
  final List<String>? autofillHints;
  final bool? loginField;
  final Icon? labelIcon;
  final TextStyle? style;
  final Color? color;
  final bool? readOnly;
  final bool? enable;
  final int? Maxlength;
  final String? CounterText;
  final void Function()? onTap;
  final String? initialValue;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputformat;
  final TextEditingController? textEditingController;
  final Icon? icon;
  final IconButton? suffixIcon;
  final List<String? Function(String?)>? validators;
  final Function(String?)? onChanged;
  final TextInputAction? textInputAction;
  final bool? required;
  final int? MaxLines;
  final bool? isLarge;
  final FocusNode? textfieldFocus;
  const CustomTextField(
      {super.key,
        required this.name,
        required this.placeHolder,
        this.icon,
        this.fieldKey,
        this.MaxLines,
        this.labelIcon,
        this.labelName,
        this.style,
        this.color,
        this.Maxlength,
        this.CounterText,
        this.loginField = false,
        this.validators,
        this.initialValue,
        this.keyBoardType,
        this.textEditingController,
        this.suffixIcon,
        this.inputformat,
        this.readOnly = false,
        this.onChanged,
        this.autofillHints,
        this.onTap,
        this.isLarge = false,
        this.enable = true,
        this.textInputAction,
        this.textfieldFocus,
        this.required = false});

  @override
  Widget build(BuildContext context) {
    /*final defaultValidators = [
        FormBuilderValidators.required(errorText: '${labelName} is required'),
        // FormBuilderValidators.minLength(1,
        //     errorText: 'Password must be at least 8 characters long'),
        // FormBuilderValidators.maxLength(15,
        //     errorText: 'Password must not exceed 15 characters'),
        // FormBuilderValidators.match(RegExp(r'(?=.*?[A-Z])'),
        //     errorText: 'Password must contain at least one uppercase letter'),
      ];*/
    final mergedValidators = [
      if (validators != null) ...validators!,
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelName != null) ...[
          Row(
            children: [
              Icon(
                labelIcon?.icon,
                size: 16.sp,
                color: Colors.black,
              ),
              SizedBox(width: 5.w),
              Text(labelName!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color:Colors.black,)),
              SizedBox(
                width: 5.w,
              ),
              if (required!)
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red.shade400,
                  ),
                ),
            ],
          ),
          SizedBox(height: 6.h),
        ],
        FormBuilderTextField(
          key: fieldKey, // Avoid duplicate keys
          name: name,
          focusNode: textfieldFocus,
          maxLength: Maxlength,
          maxLines: isLarge! ? 5 : (MaxLines ?? 1),
          onTap: onTap,
          enabled: enable!,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: textEditingController,
          autofillHints: autofillHints,
          initialValue: initialValue,
          style: style,
          inputFormatters: inputformat,
          keyboardType: keyBoardType ?? TextInputType.text,
          textInputAction: textInputAction,
          readOnly: readOnly!,

          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: color ?? Colors.black26,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Theme.of(context).focusColor,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.red, // Border color when focused
                  width: 1.0,
                )),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.red, // Border color when focused
                width: 1.0,
              ),
            ),
            counterText: CounterText,
            errorStyle: TextStyle(color: loginField! ? Colors.red : Colors.red),
            hintText: placeHolder,
            hintStyle: TextStyle(
              fontSize: 11.5.sp,
            ),
            prefixIcon: icon,
            fillColor: Theme.of(context).cardColor,
            suffixIcon: suffixIcon,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.0).r,
              borderSide: const BorderSide(
                color:
                Colors.transparent, // Border color when focused
                width: 1.0,
              ),
            ),
            contentPadding: isLarge!
                ? const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0).r
                : const EdgeInsets.symmetric(vertical: 17.0, horizontal: 10.0)
                .r,
          ),
          validator: FormBuilderValidators.compose(mergedValidators),

          onChanged: onChanged,
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
