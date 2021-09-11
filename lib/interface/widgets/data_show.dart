import 'package:deolhonafila/classes/posto.dart';
import 'package:deolhonafila/interface/widgets/titleValue.dart';
import 'package:flutter/material.dart';

class DataShow extends StatelessWidget {
  final Posto? posto;
  final GestureTapCallback? onClose;
  final GestureTapCallback? onMap;
  const DataShow({Key? key, this.posto, this.onMap, this.onClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.posto == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  posto!.name,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.start,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Astrazeneca",
                        style: TextStyle(
                            color:
                                posto!.astrazeneca ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "CoronaVac",
                        style: TextStyle(
                            color: posto!.coronavac ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Pfizer",
                        style: TextStyle(
                            color: posto!.pfizer ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SelectableText(posto!.address),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NameValue("Tipo", posto!.type),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NameValue("Status", posto!.queueStatusStr),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NameValue("Ult. Atual.", posto!.time),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: this.onMap,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.exit_to_app),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Abrir em mapa externo'),
                            ],
                          ),
                        )),
                    ElevatedButton(
                        onPressed: this.onClose,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Fechar'),
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          );
  }
}
