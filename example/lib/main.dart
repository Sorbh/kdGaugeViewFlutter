import 'package:flutter/material.dart';
import 'package:kdgaugeview/kdgaugeview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'KdGaugeView Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final speedNotifier = ValueNotifier<double>(10);
  final key = GlobalKey<KdGaugeViewState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400,
              height: 400,
              padding: EdgeInsets.all(10),
              child: ValueListenableBuilder<double>(
                  valueListenable: speedNotifier,
                  builder: (context, value, child) {
                    print(value);
                    return KdGaugeView(
                      key: key,
                      minSpeed: 0,
                      maxSpeed: 100,
                      speed: 70,
                      animate: false,
                      alertSpeedArray: [40, 80, 90],
                      alertColorArray: [Colors.orange, Colors.indigo, Colors.red],
                      duration: Duration(seconds: 6),
                    );
                  }),
            ),
            ValueListenableBuilder<double>(
              valueListenable: speedNotifier,
              builder: (context, value, child) => Slider(
                onChanged: (value) {
                  key.currentState!.updateSpeed(value);
                  speedNotifier.value = value;
                },
                max: 200,
                min: 10,
                value: value,
              ),
            )
          ],
        ),
      ),
    );
  }
}
