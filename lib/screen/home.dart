import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

var counter = 0;
String _counterKey = 'home_key';

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.openBox('Hive');
    final box = Hive.box('Hive');
    final _value = box.get(_counterKey, defaultValue: 0);
    setState(() {
      counter = _value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: increment,
        label: Text('Increment'),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 39, 39),
        centerTitle: true,
        title: Text(
          'Hive',
          style: TextStyle(color: const Color.fromARGB(255, 235, 209, 15)),
        ),
      ),
      body: Center(
        child: Text(
          "$counter",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }

  void increment() {
    final box = Hive.box('Hive');
    setState(() {
      counter = counter + 1;
    });
    box.put(_counterKey, counter);
  }
}
