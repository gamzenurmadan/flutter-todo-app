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
  ToDo({
    required this.id,
    required this.name,
    required this.completeStatus,
  });

  final int id;
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
  int _idCounter = 0;
  final TextEditingController _textFieldController = TextEditingController();

  void _addTodoItem(String name) {
    setState(() {
      _idCounter++;
      _todos.add(ToDo(id: _idCounter, name: name, completeStatus: false));
    });
    _textFieldController.clear();
  }

  void _handleTodoChange(int id) {
    final todo = _todos.firstWhere((element) => element.id == id);
    setState(() {
      todo.completeStatus = !todo.completeStatus;
    });
  }

  void _deleteToDo(int id) {
    setState(() {
      _todos.removeWhere((element) => element.id == id);
    });
  }

  void _editToDo(ToDo todo) async {
    final editedName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController editController =
        TextEditingController(text: todo.name);

        return AlertDialog(
          title: const Text('Edit ToDo'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Edit your ToDo'),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(editController.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (editedName != null) {
      setState(() {
        todo.name = editedName;
      });
    }
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
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white70, Colors.white12],
          ),
        ),
        child: _todos.isEmpty ?
            const Center(
              child: Text('No todo exists right now.\nPlease create one and track your work!',
                style: TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,),
            )
        :ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            final todo = _todos[index];
            return Card(
              elevation: 4,
              child: ListTile(
                onTap: () => _handleTodoChange(todo.id),
                leading: Checkbox(
                  checkColor: Colors.greenAccent,
                  activeColor: Colors.red,
                  value: todo.completeStatus,
                  onChanged: (_) => _handleTodoChange(todo.id),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                      Icons.edit,
                      color: Colors.amberAccent,
                ),
                    onPressed: () => _editToDo(todo),
                ),
                    IconButton(
                      icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                  ),
                  onPressed: () => _deleteToDo(todo.id),
                ),
              ],
              ),
              ),
            );
          },
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
