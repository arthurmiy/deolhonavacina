import 'package:flutter/material.dart';

class NameValue extends StatelessWidget {
  final String name;
  final String value;
  const NameValue(this.name, this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SelectableText(name,
            style: TextStyle(
                fontFamily: 'SourceSansPro', fontWeight: FontWeight.bold)),
        SelectableText(value, style: TextStyle(fontFamily: 'SourceSansPro')),
      ],
    );
  }
}
