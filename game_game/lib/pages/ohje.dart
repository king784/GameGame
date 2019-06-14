import 'package:flutter/material.dart';

class Ohje extends StatefulWidget {
  @override
  _OhjeState createState() => _OhjeState();
}

class _OhjeState extends State<Ohje> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ohje',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: <Widget>[
          Image(
            fit: BoxFit.fill,
            image: NetworkImage(
                'https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwjFx6SCv-jiAhUuxosKHQD-A7oQjRx6BAgBEAU&url=https%3A%2F%2Fme.me%2Fi%2Fmy-pain-is-far-greater-than-yours-14384539&psig=AOvVaw31NCq7OjBClQ1Y2azs0M7v&ust=1560585107657215'),
          ),
        ],
      ),
    );
  }
}
