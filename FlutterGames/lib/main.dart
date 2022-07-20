import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'gamesDetails.dart';
import 'myGamesSave.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyGames(),
    theme: new ThemeData.dark(),
  ));
}

class MyGames extends StatefulWidget {
  @override
  _MyGamesState createState() => new _MyGamesState();
}

class _MyGamesState extends State<MyGames> {
  List data;
  Future<List> getGames() async {
    var response = await http.get(
        Uri.encodeFull(
            "https://api-endpoint.igdb.com/games/?search=Halo&fields=*"),
        headers: {
          "user-key": "1934aa7e7648a7fb352d0be3aa795b48",
          "Accept": "application/json"
        });
    this.setState(() {
      data =json.decode(response.body);
    });
    print(data);
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGames();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Games Library"),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountEmail: new Text("hugo-leboucq@hotmail.fr"),
              accountName: new Text("Eraaz"),
              currentAccountPicture: new CircleAvatar(
                child: new Text("E"),
              ),
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new NetworkImage(
                          "http://wp-plugins-directory.com/wp-content/uploads/igdb-widget-preview.png"),
                      fit: BoxFit.cover)),
            ),
            new ListTile(
                title: new Text("My Games"),
                trailing: new Icon(Icons.games),
                onTap: () {
                  var route = new MaterialPageRoute(
                      builder: (BuildContext context) => new MyGamesSave());
                  Navigator.of(context).push(route);
                }),
          ],
        ),
      ),
      body: new Container(
        child: new ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                child: new Container(
                  padding: new EdgeInsets.all(10.0),
                  child: new ListTile(
                    title: new Text("http:" + data[index]['cover']['url']),
                    onTap: () {
                      var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new GamesDetails(
                              name: data[index]['name'],
                              cover: data[index]['cover']['cloudinary_id'],
                            ),
                      );
                      Navigator.of(context).push(route);
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}
