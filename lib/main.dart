import 'package:flutter/material.dart';
import 'slot.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checklist App',
      initialRoute: '/',
      routes: {'/': ((context) => const MyHomePage(title: 'To Do App'))},
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Slot> tasks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.all(10),
          child: Column(
            children: [
                  Padding(padding: const EdgeInsets.all(10), child: ElevatedButton(
                      child: const Text('Add Task',
                          style: TextStyle(fontSize: 25)),
                      onPressed: () {
                        ManagerSlot managerSlot = ManagerSlot(
                            date: DateFormat('yMd').format(DateTime.now()),
                            time: TimeOfDay.now().format(context));
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text(
                                    'Add Task',
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 18),
                                  ),
                                  content: managerSlot,
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() => tasks.add(Slot(
                                              managerSlot.title,
                                              managerSlot.details,
                                              managerSlot.date,
                                              managerSlot.time)));
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Add',
                                          style: TextStyle(fontSize: 20),
                                        )),
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel',
                                            style: TextStyle(fontSize: 20)))
                                  ],
                                ));
                      })),
              Flexible(
                child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: ((context, i) {
                      return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: tasks[i]
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() => tasks.removeAt(i));
                                },
                              ),
                            ],
                          ));
                    })),
              )
            ],
          )),
      backgroundColor: Colors.black87,
    );
  }
}
