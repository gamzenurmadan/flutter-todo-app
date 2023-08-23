import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        fontFamily: 'Raleway',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'My ToDo List'),
    );
  }
}

class ToDo {
  ToDo({required this.name, required this.completeStatus});
  String name;
  bool completeStatus;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<ToDo> _todos = [];
  final TextEditingController _textFieldController = TextEditingController();

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(ToDo(name: name, completeStatus: false));
    });
    _textFieldController.clear();
  }

  void _handleTodoChange(ToDo todo) {
    setState(() {
      todo.completeStatus = !todo.completeStatus;
    });
  }

  void _deleteToDo(ToDo todo) {
    setState(() {
      _todos.removeWhere((element) => element.name == todo.name);
    });
  }

  Future<void> _displayDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a ToDo'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your ToDo'),
            autofocus: true,
          ),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.title,
        style: TextStyle(
          fontSize: 24,
            fontWeight: FontWeight.bold
        ),)
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white70, Colors.white12],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: _todos.map((todo) {
            return Card(
              elevation: 4,
              child: ListTile(
                onTap: () => _handleTodoChange(todo),
            leading: Checkbox(
            checkColor: Colors.greenAccent,
            activeColor: Colors.red,
            value: todo.completeStatus,
            onChanged: (_) => _handleTodoChange(todo),
            ),
            title: Text(
            todo.name,
            style: TextStyle(
            fontSize: 18,
            decoration: todo.completeStatus
            ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.completeStatus ? Colors.black54 : Colors.black,
            ),
            ),
            trailing: IconButton(
            icon: Icon(
            Icons.delete,
            color: Colors.red,
            ),
            onPressed: () => _deleteToDo(todo),
              ),
            ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayDialog,
        tooltip: 'Add ToDo',
        backgroundColor: Colors.white70,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({
    Key? key,
    required this.todo,
    required this.onToDoChange,
    required this.onRemoveTodo,
  }) : super(key: key);

  final ToDo todo;
  final void Function(ToDo todo) onToDoChange;
  final void Function(ToDo todo) onRemoveTodo;

  TextStyle? _getTextStyle(bool checked) {
    return checked
        ? const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onToDoChange(todo),
      leading: Checkbox(
        checkColor: Colors.greenAccent,
        activeColor: Colors.red,
        value: todo.completeStatus,
        onChanged: (_) => onToDoChange(todo),
      ),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              todo.name,
              style: _getTextStyle(todo.completeStatus),
            ),
          ),
          IconButton(
            iconSize: 30,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            alignment: Alignment.centerRight,
            onPressed: () => onRemoveTodo(todo),
          ),
        ],
      ),
    );
  }
}
