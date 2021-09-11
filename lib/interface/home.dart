import 'dart:convert';
// import 'package:share_plus/share_plus.dart';
import 'package:deolhonafila/classes/converter.dart';
import 'package:deolhonafila/classes/posto.dart';
import 'package:deolhonafila/interface/map.dart';
import 'package:deolhonafila/interface/widgets/search_menu.dart';
import 'package:deolhonafila/interface/widgets/simple_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
// import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  static final String route = '/';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  List<Posto> lista = [];
  List<Posto> fList = [];
  Map<String, String> filter = {
    "Bairro": "",
    "Tipo": "",
    "Região": "",
    "Status da fila": "",
    "Tipo de segunda dose": ""
  };

  //filter data
  void filterData() {
    List<Posto> filteredList = lista;
    List<Posto> tmplist = [];
    for (String key in filter.keys) {
      if (key.toLowerCase() == "tipo de segunda dose") {
        if (filter[key]!.toLowerCase() == "coronavac") {
          for (int i = 0; i < filteredList.length; i++) {
            if (filteredList[i].coronavac) {
              tmplist.add(filteredList[i]);
            }
          }
        } else if (filter[key]!.toLowerCase() == "pfizer") {
          for (int i = 0; i < filteredList.length; i++) {
            if (filteredList[i].pfizer) {
              tmplist.add(filteredList[i]);
            }
          }
        } else if (filter[key]!.toLowerCase() == "astrazeneca") {
          for (int i = 0; i < filteredList.length; i++) {
            if (filteredList[i].astrazeneca) {
              tmplist.add(filteredList[i]);
            }
          }
        } else {
          tmplist = filteredList;
        }
      } else {
        if (filter[key] == "") {
          tmplist = filteredList;
        } else {
          for (int i = 0; i < filteredList.length; i++) {
            if (filteredList[i].getParameterByLabel(key) == filter[key]) {
              tmplist.add(filteredList[i]);
            }
          }
        }
      }
      filteredList = tmplist;
      tmplist = [];
    }

    fList = filteredList;
    List<Marker> tmpMarkerList = [];
    for (var iTmp in filteredList) {
      LatLon tmp = converter[iTmp.name] ?? LatLon(0, 0);
      tmpMarkerList.add(Marker(
        width: 30.0,
        height: 50.0,
        point: LatLng(tmp.lat, tmp.lon),
        builder: (ctx) => Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: IconButton(
                  padding: EdgeInsets.symmetric(vertical: 0.1, horizontal: 0.1),
                  iconSize: 30,
                  icon: Icon(
                    Icons.local_hospital_rounded,
                    color: colorConverter[iTmp.queueStatus] ?? Colors.black,
                  ),
                  onPressed: () {
                    callbackIcon(iTmp);
                  },
                ),
              ),
              FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('A',
                        style: TextStyle(
                            color: iTmp.astrazeneca ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold)),
                    Text('C',
                        style: TextStyle(
                            color: iTmp.coronavac ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold)),
                    Text('P',
                        style: TextStyle(
                            color: iTmp.pfizer ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    }
    markersList = tmpMarkerList;
  }

  // void fillList() async {
  //   int counter = 0;
  //   String export = "{\n";
  //   for (var il = 360; il < lista.length; il++) {
  //     counter = il;
  //     var i = lista[il];
  //     try {
  //       List<Location> locations = await locationFromAddress(i.address);
  //       print(counter / lista.length);
  //       export += '"' +
  //           i.name +
  //           '": new LatLon(' +
  //           locations[0].latitude.toString() +
  //           ',' +
  //           locations[0].longitude.toString() +
  //           '),\n';
  //     } catch (err) {
  //       export += '"' + i.name + '": new LatLon(0.0,0.0),\n';
  //     }
  //   }
  //   export += '\n }';
  //
  //   Share.share(export);
  // }

  //retrieves data from internet
  Future<void> getData() async {
    var url = Uri.parse('https://v4c1n4.rj.r.appspot.com/');
    http.Response response = await http
        .get(url, headers: {'Content-type': 'application/json; charset=utf-8'});

    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = jsonDecode(response.body);
      //retrieve complete list
      lista = List<Posto>.from(parsedListJson.map((i) => Posto.fromJson(i)));
      filterData();
      // fillList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    callbackIcon = (value) {};
    reset();
  }

  Future<void> reset() async {
    filter = {
      "Bairro": "",
      "Tipo": "",
      "Região": "",
      "Status da fila": "",
      "Tipo de segunda dose": ""
    };
    await getData();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: loading
              ? CircularProgressIndicator()
              : Container(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Pesquisar postos de vacinação",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      SearchMenu(fList, filter, (value) {
                        filter = value;

                        filterData();
                        setState(() {});
                      }),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                loading = true;
                                setState(() {});
                                await reset();
                                setState(() {
                                  loading = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.refresh),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Limpar e atualizar'),
                                  ],
                                ),
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(MapView.route);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.map_outlined),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Ver no mapa'),
                                  ],
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: fList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return SimpleTile(fList[index]);
                          },
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
