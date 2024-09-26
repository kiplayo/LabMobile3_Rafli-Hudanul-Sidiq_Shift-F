import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<String> _books = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _books = prefs.getStringList('books') ?? [];
    });
  }

  void _addBook() async {
    if (_controller.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      _books.add(_controller.text);
      await prefs.setStringList('books', _books);
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Add New Book'),
            ),
          ),
          ElevatedButton(onPressed: _addBook, child: Text('Add Book')),
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_books[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
