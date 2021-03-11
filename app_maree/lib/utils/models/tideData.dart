import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<TideData>> fetchDataList() async {
  final response = await http.get(
      'http://dati.venezia.it/sites/default/files/dataset/opendata/livello.json');
  if (response.statusCode == 200) {
    // final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    // avendo una lista di json, non un oggetto json possiamo usare anche il seguente
    final parsed = json.decode(response.body);
    // print('body parsed $parsed');
    return parsed.map<TideData>((json) => TideData.fromJson(json)).toList();
  } else {
    throw Exception('Failed to get Data');
  }
}

class TideData {
  /*
  {
    "ordine":"2",
    "ID_stazione":"01033",
    "stazione":"Chioggia porto",
    "nome_abbr":"Ch_Porto",
    "latDMSN":"451357.00",
    "lonDMSE":"121650.00",
    "latDDN":"45.232500",
    "lonDDE":"12.280556",
    "data":"2020-01-02 16:50:00",
    "valore":"-0.03 m"
    }
  */

  final String ordine;
  final String idStazione;
  final String stazione;
  final String nomeAbbr;
  final String latDMSN;
  final String lonDMSE;
  final String latDDN;
  final String lonDDE;
  final String data;
  final String valore;

  TideData(
      {this.ordine,
      this.idStazione,
      this.stazione,
      this.nomeAbbr,
      this.latDMSN,
      this.lonDMSE,
      this.latDDN,
      this.lonDDE,
      this.data,
      this.valore});

  // getter
  double get valoreDouble => double.parse(valore.split(' ')[0]);

  // a factory named constructor
  factory TideData.fromJson(Map<String, dynamic> json) {
    return TideData(
        ordine: json['ordine'] as String,
        idStazione: json['ID_stazione'] as String,
        stazione: json['stazione'] as String,
        nomeAbbr: json['nome_abbr'] as String,
        latDMSN: json['latDMSN'] as String,
        lonDMSE: json['lonDMSE'] as String,
        latDDN: json['latDDN'] as String,
        lonDDE: json['lonDDE'] as String,
        data: json['data'] as String,
        valore: json['valore'] as String);
  }
}