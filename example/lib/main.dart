import 'package:bdaya_custom_splash/bdaya_custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Builder(
        builder: (context) {
          return BdayaCustomSplash(
            splashDuration: 10,
            backgroundBuilder: (child) {
              return Container(color: Colors.blue, child: child);
            },
            shimmerBuilder: (child) {
              return Shimmer.fromColors(
                  child: child,
                  baseColor: Colors.transparent,
                  highlightColor: Colors.black);
            },
            initFunction: () async {
              return null;
            },
            logoBuilder: () {
              return Center(
                child: Container(
                  color: Colors.red,
                  height: 200,
                  width: 200,
                ),
              );
            },
            onNavigateTo: (result) async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MyHomePage(
                    title: 'Hi Bdaya',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
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
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
