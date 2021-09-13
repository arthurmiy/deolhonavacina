import 'package:deolhonafila/classes/posto.dart';
import 'package:deolhonafila/interface/widgets/titleValue.dart';
import 'package:flutter/material.dart';

class SimpleTile extends ListTile {
  SimpleTile(
    Posto posto,
  ) : super(
          title: SelectableText(posto.name,
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SelectableText(posto.address,
                style: TextStyle(fontFamily: 'SourceSansPro')),
            NameValue('Tipo: ', posto.type),
            NameValue('Região: ', posto.Region),
            NameValue('Status: ', posto.queueStatusStr),
            NameValue('Atualizado em:', posto.time),
          ]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
          ),
        );
}
