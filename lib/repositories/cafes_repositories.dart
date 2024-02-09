import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class DB {
  DB._();
  static final DB _instance = DB._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static get() {
    return DB._instance._firestore;
  }

  static city() async {
    FirebaseFirestore firestore = DB.get();

    final cities = firestore.collection("cities");
    final data1 = <String, dynamic>{
      "name": "San Francisco",
      "state": "CA",
      "country": "USA",
      "capital": false,
      "population": 860000,
      "regions": ["west_coast", "norcal"]
    };
    cities.doc("SF").set(data1);

    final data2 = <String, dynamic>{
      "name": "Los Angeles",
      "state": "CA",
      "country": "USA",
      "capital": false,
      "population": 3900000,
      "regions": ["west_coast", "socal"],
    };
    cities.doc("LA").set(data2);

    final data3 = <String, dynamic>{
      "name": "Washington D.C.",
      "state": null,
      "country": "USA",
      "capital": true,
      "population": 680000,
      "regions": ["east_coast"]
    };
    cities.doc("DC").set(data3);

    final data4 = <String, dynamic>{
      "name": "Tokyo",
      "state": null,
      "country": "Japan",
      "capital": true,
      "population": 9000000,
      "regions": ["kanto", "honshu"]
    };
    cities.doc("TOK").set(data4);

    final data5 = <String, dynamic>{
      "name": "Beijing",
      "state": null,
      "country": "China",
      "capital": true,
      "population": 21500000,
      "regions": ["jingjinji", "hebei"],
    };
    cities.doc("BJ").set(data5);
  }

  static setupDemoData() async {
    FirebaseFirestore firestore = DB.get();
    final geo = GeoFlutterFire();

    List<GeoFirePoint> cafes = [
      geo.point(latitude: -27.353675, longitude: -49.881988),
      geo.point(latitude: -27.355669, longitude: -49.883449),
      geo.point(latitude: -27.356121, longitude: -49.880632),
      geo.point(latitude: -27.357664, longitude: -49.883852),
      geo.point(latitude: -27.361671, longitude: -49.890589),
    ];
    final dados = [
      {
        'nome': 'The Coffee',
        'imagem':
            'https://thecoffee.s3-sa-east-1.amazonaws.com/images/the_coffee_berrini.jpeg',
        'position': cafes[0].data,
      },
      {
        'nome': 'The Coffee II',
        'imagem':
            'https://thecoffee.s3-sa-east-1.amazonaws.com/images/SP-Itaim-2.jpg',
        'position': cafes[1].data,
      },
      {
        'nome': 'The Coffee III',
        'imagem':
            'https://thecoffee.s3-sa-east-1.amazonaws.com/images/the_coffee_market_place.jpeg',
        'position': cafes[2].data,
      },
      {
        'nome': 'The Coffee IV',
        'imagem':
            'https://lh5.googleusercontent.com/p/AF1QipN2DS1CHddvUSz1IoLxP6Y411SPgFY2qefVDoah=w408-h544-k-no',
        'position': cafes[3].data,
      },
      {
        'nome': 'The Coffee Faria Lima',
        'imagem':
            'https://lh5.googleusercontent.com/p/AF1QipN2DS1CHddvUSz1IoLxP6Y411SPgFY2qefVDoah=w408-h544-k-no',
        'position': cafes[4].data,
      },
    ];

    for (var element in dados) {
      {
        await firestore.collection('cafes').add(element);
      }
    }
  }
}
