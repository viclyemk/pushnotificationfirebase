import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_handleMessage);

  runApp(const MyApp());
}

  String messageTitle = "Empty";
  String notificationAlert = "alert";

Future<void> _handleMessage(RemoteMessage message) async{
  notificationAlert = message.notification!.title.toString();
  messageTitle = message.notification!.body.toString();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      print('token is : $value');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        notificationAlert = message.notification!.title.toString();
        messageTitle = message.notification!.body.toString();
      });
      print('message received!');
      print('message is: ${message.notification!.body}');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Notification from firebase!'),
                content: Text(message.notification!.body.toString()),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });


    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        notificationAlert = event.notification!.title.toString();
        messageTitle = event.notification!.body.toString();
      });
    });
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              notificationAlert,
            ),
            Text(
              messageTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}

