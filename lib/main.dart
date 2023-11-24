import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/shared_pref_helper.dart';
import 'package:todo_app/todo_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TODO APP'),
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
  // Add Controller

  TextEditingController controller = TextEditingController();
  List<Todo> _todos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _todos = SharedPreferencesHelper.getTodos();
  }

  void _addTodo() {
    final todo = Todo(
      id: DateTime.now().toString(),
      content: controller.text,
    );
    SharedPreferencesHelper.saveToDo(todo).then((value) {
      setState(() {
        _todos.add(todo);
        controller.clear();
      });
    });
  }

  void _deleteTodo(String id) {
    SharedPreferencesHelper.deleteTodo(id).then((value) {
      setState(() {
        _todos.removeWhere((todo) => todo.id == id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        title: Text(
          "TODO APP",
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          )),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(child: TextField(controller: controller)),
              ElevatedButton(
                onPressed: _addTodo,
                child: Text('Add TODO'),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: List.generate(
                _todos.length,
                (index) => ListTile(
                  title: Text('${index + 1}.${_todos[index].content}'),
                  trailing: GestureDetector(
                    onTap: () {
                      _deleteTodo(_todos[index].id);
                    },
                    child: Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
