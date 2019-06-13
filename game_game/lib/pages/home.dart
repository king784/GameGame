import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pelin tiedot',
            style: TextStyle(color: Colors.green),
          ),
          backgroundColor: Colors.black,
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://images.cdn.yle.fi/image/upload//w_1199,h_799,f_auto,fl_lossy,q_auto:eco/13-3-8654556.jpg'),
                  ),
                ),
              ),
              ListTile(
                title: Text('Pelin tiedot',
                    style: TextStyle(fontSize: 20, color: Colors.green)),
                trailing: Icon(
                  Icons.home,
                  color: Colors.green,
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Aktiviteettejä',
                    style: TextStyle(fontSize: 20, color: Colors.green)),
                trailing: Icon(
                  Icons.beach_access,
                  color: Colors.green,
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Ohje',
                    style: TextStyle(fontSize: 20, color: Colors.green)),
                trailing: Icon(
                  Icons.help,
                  color: Colors.green,
                ),
              ),
              Divider(),
              ListTile(
                title: Text('Peruuta',
                    style: TextStyle(fontSize: 20, color: Colors.green)),
                trailing: Icon(
                  Icons.cancel,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        body: Center(
            child: Text(
          'data',
          style: TextStyle(fontSize: 35.0, color: Colors.green),
        )));
  }
}
