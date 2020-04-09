import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HotelHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TravelList();
  }
}

class TravelList extends StatefulWidget {
  @override
  _TravelListState createState() => _TravelListState();
}

class _TravelListState extends State<TravelList> {
  StreamController<TravelApi> streamController;
  List<TravelApi> list = [];

  @override
  void initState() {
    // TODO: implement initState
    streamController = StreamController.broadcast();
    streamController.stream.listen((p) => setState(() => list.add(p)));
    Load(streamController);

  }

  Load(StreamController sc) async {
    String url = 'https://bmc.guide.siqware.com/api/travel-api';
    var client =new http.Client();
    var req = new http.Request('get', Uri.parse(url));
    var streamRes = await client.send(req);
    streamRes.stream.transform(utf8.decoder).transform(json.decoder).expand((element) => element).map((map) => TravelApi.fromJsonMap(map)).pipe(streamController);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamController?.close();
    streamController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Api'),
      ),
      body: Center(
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) => _makeElement(index),
        ),
      ),
    );
  }
  Widget _makeElement(int index){
    if(index >= list.length){
      return null;
    }

    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Text(list[index].title),
          Image.network(list[index].thumbnail)
        ],
      ),
    );
  }

}

class TravelApi {
  int id;
  String title;
  String thumbnail;
  String description;
  String location;
  String locationUrl;
  String category;
  bool status;
  int views;
  dynamic gallery;
  String createdAt;

  TravelApi.fromJsonMap(Map map) :
        title = map['title'],
        thumbnail = map['thumbnail'];
}
