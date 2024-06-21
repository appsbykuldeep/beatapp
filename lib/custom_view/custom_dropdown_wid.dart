import 'package:beatapp/utility/extentions/context_ext.dart';
import 'package:flutter/material.dart';

class DropdownWid<T extends DropDownData> extends StatelessWidget {
  final List<T> itemslist;
  final T? selectedvalue;
  final String? labletext;
  final String? hinttext;
  final ValueChanged<T> onchange;
  final bool enable;
  final bool expanded;
  final double? height;
  final double? width;
  final InputBorder? outlineborder;
  final FocusNode? focusNode;
  final bool firstSelected;
  final bool isDense;
  final String? Function(T?)? validator;

  const DropdownWid({
    Key? key,
    required this.itemslist,
    required this.onchange,
    this.selectedvalue,
    this.hinttext,
    this.enable = true,
    this.expanded = true,
    this.height,
    this.width,
    this.labletext,
    this.outlineborder,
    this.focusNode,
    this.firstSelected = true,
    this.isDense = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isinList = itemslist.contains(selectedvalue);

    return SizedBox(
      width: width,
      height: height,
      child: AbsorbPointer(
        absorbing: !enable,
        //DropdownButtonFormField
        child: DropdownButtonFormField<T>(
          focusNode: focusNode,
          isExpanded: expanded,

          validator: validator,

          // value: selectedvalue,
          value: isinList
              ? selectedvalue
              : (firstSelected && itemslist.isNotEmpty)
                  ? itemslist[0]
                  : null,
          dropdownColor: context.colorScheme.surface,
          // icon: Image.asset(
          //   Assets.image_drop_down,
          //   height: 40,
          //   width: 40,
          // ),
          // focusColor: primaryswatch,
          decoration: InputDecoration(
            enabled: enable,
            isDense: isDense,
            labelText: labletext == null ? null : (labletext ?? ""),
            contentPadding: const EdgeInsets.fromLTRB(8, 2, 5, 1),
            border: const OutlineInputBorder(),
            enabledBorder: outlineborder,
            focusedBorder: outlineborder,
          ),

          // underline: const SizedBox(),
          style: TextStyle(
            color: context.colorScheme.primary,
          ),

          items: itemslist
              // .toSet()
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(e.dropLabel),
                ),
              )
              .toList(),
          hint: Text(hinttext ?? ''),
          onChanged: (value) {
            if (value == null) return;
            onchange(value);
          },
        ),
      ),
    );
  }
}

class DropDownData {
  String dropLabel;
  DropDownData({
    this.dropLabel = "",
  });
}
