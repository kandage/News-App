import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class AddNoteScreen extends StatefulWidget {
  final Map<String, dynamic>? existingNote; // For editing a note (optional)

  const AddNoteScreen({Key? key, this.existingNote}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _notes = []; // List of all notes

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      // Populate fields if editing an existing note
      _titleController.text = widget.existingNote!['title'];
      _contentController.text = widget.existingNote!['content'];
    }
    _loadNotes(); // Load all notes on screen initialization
  }

  Future<void> _loadNotes() async {
    final notes = await _dbHelper.fetchNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      if (widget.existingNote != null) {
        await _dbHelper.updateNote(
          widget.existingNote!['id'],
          {'title': title, 'content': content},
        );
      } else {
        await _dbHelper.insertNote({'title': title, 'content': content});
      }
      await _loadNotes(); // Refresh list
      _clearFields(); // Clear input fields
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and content cannot be empty!")),
      );
    }
  }


  Future<void> _deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
    _loadNotes(); // Refresh notes list
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Note deleted successfully!")),
    );
  }

  void _clearFields() {
    _titleController.clear();
    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Column(
        children: [
          // Input Fields
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Content",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _saveNote,
                  child: const Text("Save Note"),
                ),
              ],
            ),
          ),

          // Notes List
          const Divider(),
          const Text(
            "Your Notes",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: _notes.isEmpty
                ? const Center(child: Text("No notes found"))
                : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return ListTile(
                  title: Text(note['title']),
                  subtitle: Text(note['content']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteNote(note['id']),
                  ),
                  onTap: () {
                    // Open note for editing
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddNoteScreen(existingNote: note),
                      ),
                    ).then((_) => _loadNotes());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
