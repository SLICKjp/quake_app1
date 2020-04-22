import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


void main() async {
  Map data=await getQuake();
  List _features = data['features'];
  print(data);
  runApp(new MaterialApp(
    home: new Scaffold(
      appBar: new AppBar(
        title: new Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount:_features.length,
            padding: EdgeInsets.all(16.8),
            itemBuilder:(BuildContext context,int position){
            if(position.isOdd) return Divider();
       //     final index=position~/2;
            var format=new DateFormat.yMd().add_jm();
            var date=format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[position]['properties']['time']*1000,
            isUtc: true));
            return new ListTile(
              title: Text("$date",
              style: TextStyle(fontSize: 18.5,fontStyle: FontStyle.normal,color: Colors.orange,

              ),
              ),
              subtitle: Text("${_features[position]['properties']['place']}",
              style: TextStyle(fontSize: 18.5,fontStyle: FontStyle.normal),
              ),

              leading: new CircleAvatar(
              backgroundColor: Colors.green,
                child: Text("${_features[position]['properties']['mag']}"
              ),
            ),
              onTap: () {_showOnTapMessage(context, "${_features[position]['properties']['title']}"); }
            );
      }
      ),
    ),
    ),
  ));
}
void _showOnTapMessage(BuildContext context,String message) {
  var alert = new AlertDialog(
    title: new Text('Quakes'),
    content: Text(message),
    actions: <Widget>[
      new FlatButton(onPressed: () {
        Navigator.pop(context);
      },
          child: Text('OK'))
    ],
  );
  showDialog(context: context,child: alert);
}


Future<Map> getQuake() async {
   String apiUrl="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
   http.Response response=await http.get(apiUrl);
   return jsonDecode(response.body);
}