import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import 'add_note_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final DBHelper _dbHelper = DBHelper(); // Database helper instance
  List<Map<String, dynamic>> _notes = []; // List to hold notes

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load notes from the database
  Future<void> _loadNotes() async {
    final notes = await _dbHelper.fetchNotes();
    setState(() {
      _notes = notes;
    });
  }

  // Navigate to AddNoteScreen and handle result
  Future<void> _navigateToAddNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNoteScreen()),
    );
    _loadNotes(); // Reload notes when returning
  }

  // Navigate to AddNoteScreen for editing
  Future<void> _navigateToEditNote(Map<String, dynamic> note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNoteScreen(existingNote: note),
      ),
    );
    _loadNotes(); // Reload notes when returning
  }

  // Delete a note
  Future<void> _deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
    _loadNotes(); // Reload notes
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Note deleted successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddNote,
          ),
        ],
      ),
      body: _notes.isEmpty
          ? const Center(child: Text("No notes found"))
          : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              title: Text(
                note['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(note['content']),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteNote(note['id']),
              ),
              onTap: () => _navigateToEditNote(note),
            ),
          );
        },
      ),
    );
  }
}
