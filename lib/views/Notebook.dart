import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:notebook/model/Note.dart';

class Notebook extends StatefulWidget {
  const Notebook({super.key});

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {
  List<Note> notes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes("can").then((value) {
      for (dynamic val in value.data) {
        setState(() {
          notes.add(Note(val["id"], val["title"], val["text"], val["userId"]));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Text(notes[index].text!);
                  },
                  itemCount: notes.length)),
          Column(
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, left: 5.0, right: 5.0, bottom: 10),
                  child: TextField(
                    mouseCursor: MouseCursor.uncontrolled,
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                width: 3 * (MediaQuery.of(context).size.width) / 4,
                height: MediaQuery.of(context).size.height / 10,
              ),
              SizedBox(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                  child: TextField(
                    mouseCursor: MouseCursor.uncontrolled,
                    textAlignVertical: TextAlignVertical.top,
                    expands: true,
                    minLines: null,
                    maxLines: null,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                width: 3 * (MediaQuery.of(context).size.width) / 4,
                height: 9 * MediaQuery.of(context).size.height / 10,
              ),
            ],
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: FloatingActionButton.small(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: FloatingActionButton.small(
              onPressed: () {},
              child: Icon(Icons.remove),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: FloatingActionButton.small(
              onPressed: () {},
              child: Icon(Icons.save),
            ),
          )
        ],
      ),
    );
  }
}

createNote(String id, String title, String text, String userId) async {
  Note note = Note(id, text, title, userId);
  await Dio().post("localhost:8080/createNote/$id/$userId/$title", data: text);
}

Future<Response<dynamic>> getNotes(String userId) async {
  try {
    return await Dio().get('http://localhost:8080/notes/$userId');
  } catch (e) {
    print("EEEERRROR: ${e.toString()}");
  }
  return Future.error("");
}
