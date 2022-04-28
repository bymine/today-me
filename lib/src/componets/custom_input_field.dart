import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String title;
  final FocusNode? focusNode;
  final String hintTitle;
  final int maxLines;
  final Widget? titleWidget;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixcIcon;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;
  final TextEditingController? controller;
  const CustomInputField({
    Key? key,
    required this.controller,
    required this.title,
    required this.hintTitle,
    this.titleWidget,
    this.prefixIcon,
    this.suffixcIcon,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
              ),
              titleWidget != null ? titleWidget! : Container()
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            focusNode: focusNode,
            readOnly: readOnly,
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              contentPadding: maxLines == 1
                  ? const EdgeInsets.only(left: 16)
                  : const EdgeInsets.all(16),
              hintText: hintTitle,
              prefixIcon: prefixIcon,
              suffixIcon: suffixcIcon,
              hintStyle: Theme.of(context).textTheme.bodySmall,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black45),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black45),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: validator,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
