import 'package:flutter/material.dart';

class DropDownOptions extends StatelessWidget {
  final List<String> options;
  final String title;
  final String value;
  final ValueChanged<String?> onChanged;

  const DropDownOptions(this.options, this.title, this.onChanged, this.value,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> opt = options;
    opt.add("");
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.start,
        ),
        DropdownButton<String>(
          isExpanded: true,
          value: value,
          iconSize: 24,
          elevation: 16,
          onChanged: onChanged,
          items: opt.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
