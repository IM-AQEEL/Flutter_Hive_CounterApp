import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controller = new TextEditingController();
  bool isBoxopen = true;
  Box? mybox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  // Open Box
  Future<void> _openBox() async {
    mybox = await Hive.openBox('my box');
    setState(() {
      isBoxopen = true;
    });
  }

  // Update Operation
  Future<void> _update(int index, String updateTask) async {
    if (mybox != null) {
      await mybox?.putAt(index, updateTask);
      if (mounted) {
        {
          setState(() {});
        }
      }
    }
  }
  // Delete Operation

  Future<void> _deleteTask(int index) async {
    if (mybox != null && index < mybox!.length) {
      await mybox?.deleteAt(index);
      setState(() {});
    }
  }
  // Add Task

  Future<void> _addTask(String task) async {
    mybox?.add(task);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ToDo App',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 150,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              TextField(
                controller: _controller,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty && isBoxopen) {
                    _addTask(_controller.text);
                  }
                },
                child: Text('Enter'),
              ),
              Expanded(
                child:
                    isBoxopen
                        ? ListView.builder(
                          itemCount: mybox?.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(mybox?.getAt(index).toString() ?? ''),
                              trailing: IconButton(
                                onPressed: () {
                                  _deleteTask(index);
                                },
                                icon: Icon(Icons.delete_outline),
                              ),
                              leading: IconButton(
                                onPressed: () {
                                  TextEditingController
                                  controller = new TextEditingController(
                                    text: mybox?.getAt(index).toString() ?? '',
                                  );
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: Text("Edit Task"),
                                          content: TextField(
                                            controller: controller,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                _update(index, controller.text);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Edit'),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
                            );
                          },
                        )
                        : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
