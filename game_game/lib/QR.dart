import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:url_launcher/url_launcher.dart';

// void main() => runApp(QRReader());

// Boolean to track if the popup menu is on.
bool popUp = false;

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class QRReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'QR reader',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CameraTest(),
    );
  }
}

class CameraTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CameraTestState();
  }
}

class CameraTestState extends State<CameraTest> {
  GlobalKey<QrCameraState> qrCameraKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: new SizedBox(
            width: 300.0,
            height: 600.0,
            child: new QrCamera(
              key: qrCameraKey,
              qrCodeCallback: (code) {
                if (popUp) {
                  qrCameraKey.currentState.stop();
                  return;
                }
                popUp = true;
                showPopUp(code);
              },
            ),
          ),
        ),
      ],
    );
  }

  void showPopUp(code) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(40.0),
            children: <Widget>[
              Center(child: Text(code + "\n")),
              Center(child: RaisedButton(
                child: Text('Open'),
                color: Colors.green,
                elevation: 4.0,
                splashColor: Colors.blueGrey,
                onPressed: () {
                  Navigator.pop(context);
                  _launchURL(code);
                }),
              ),
              Center(child: Text(" ")),
              Center(child: RaisedButton(
                child: Text('Close'),
                color: Colors.red,
                elevation: 4.0,
                splashColor: Colors.blueGrey,
                onPressed: () {
                  Navigator.pop(context);
                  popUp = false;
                  qrCameraKey.currentState.restart();
                }),
              ),
            ],
          );
        });
  }
}
