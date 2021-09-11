import 'package:deolhonafila/classes/posto.dart';
import 'package:deolhonafila/interface/widgets/dropdown.dart';
import 'package:flutter/material.dart';

class SearchMenu extends StatelessWidget {
  final List<Posto> filteredList;
  final Map<String, String> filter;
  final ValueChanged<Map<String, String>> onChanged;
  const SearchMenu(this.filteredList, this.filter, this.onChanged, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, int>> tmp = {
      "Bairro": {},
      "Tipo": {},
      "Região": {},
      "Status da fila": {},
      "Tipo de segunda dose": {"coronavac": 0, "pfizer": 0, "astrazeneca": 0}
    };
    for (var i in filteredList) {
      tmp["Bairro"]![i.getParameterByLabel("bairro")] = i.idDistrict;
      tmp["Tipo"]![i.getParameterByLabel("Tipo")] = i.idType;
      tmp["Região"]![i.getParameterByLabel("Região")] = i.idRegion;
      tmp["Status da fila"]![i.getParameterByLabel("Status da fila")] =
          i.queueStatus;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: filteredList.length > 0
          ? tmp.entries
              .map<DropDownOptions>((entry) => DropDownOptions(
                      entry.value.keys.toList(), entry.key, (newValue) {
                    Map<String, String> tmp = filter;
                    tmp[entry.key] = newValue ?? "";
                    onChanged(tmp);
                  }, filter[entry.key]!))
              .toList()
          : [Text('Sem Correspondência')],
    );
  }
}
