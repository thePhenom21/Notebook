import 'package:binary/binary.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:notebook/model/Note.dart';

String user = "";

class Notebook extends StatefulWidget {
  String username = "";
  Notebook({super.key, required this.username});

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {
  int id = 0;
  List<Note> notes = [];
  Note? currentNote = Note("", "", "", "");
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes("${widget.username}").then((value) {
      for (dynamic val in value.data) {
        setState(() {
          notes.add(Note(val["id"], val["title"], val["text"], val["userId"]));
          id++;
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
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentNote!.id = notes[index].id;
                              currentNote!.text = notes[index].text;
                              currentNote!.title = notes[index].title;
                              currentNote!.userId = notes[index].userId;
                              titleController.value =
                                  TextEditingValue(text: currentNote!.title!);
                              textController.value =
                                  TextEditingValue(text: currentNote!.text!);
                            });
                          },
                          child: Text(notes[index].title!)),
                    );
                  },
                  itemCount: notes.length)),
          Column(
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, left: 5.0, right: 5.0, bottom: 10),
                  child: TextField(
                    controller: titleController,
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
                    controller: textController,
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
              onPressed: () {
                setState(() {
                  titleController.value = TextEditingValue(text: "");
                  textController.value = TextEditingValue(text: "");
                  currentNote!.text = "";
                  currentNote!.title = "";
                  currentNote!.id = "$id";
                });
              },
              child: Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: FloatingActionButton.small(
              onPressed: () async {
                await deleteNote(currentNote!.id);
                titleController.value = TextEditingValue(text: "");
                textController.value = TextEditingValue(text: "");
                currentNote!.text = "";
                currentNote!.title = "";
                currentNote!.id = "$id";
                setState(() {
                  notes = [];
                });
                await getNotes("${widget.username}").then((value) {
                  for (dynamic val in value.data) {
                    setState(() {
                      notes.add(Note(
                          val["id"], val["title"], val["text"], val["userId"]));
                    });
                  }
                });
              },
              child: Icon(Icons.remove),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: FloatingActionButton.small(
              onPressed: () async {
                await createNote(
                    "${currentNote!.id}",
                    titleController.value.text,
                    textController.value.text,
                    "${widget.username}");
                id++;
                setState(() {
                  notes = [];
                });
                await getNotes("${widget.username}").then((value) {
                  for (dynamic val in value.data) {
                    setState(() {
                      notes.add(Note(
                          val["id"], val["title"], val["text"], val["userId"]));
                    });
                  }
                });
              },
              child: Icon(Icons.save),
            ),
          )
        ],
      ),
    );
  }
}

createNote(String id, String title, String text, String userId) async {
  try {
    await Dio().post("http://localhost:8080/createNote/$id/$userId/$title",
        data: text);
  } catch (e) {
    print(e);
  }
}

deleteNote(String id) async {
  try {
    await Dio().post("http://localhost:8080/deleteNote/$id");
  } catch (e) {
    print(e);
  }
}

Future<Response<dynamic>> getNotes(String userId) async {
  try {
    return await Dio().get('http://localhost:8080/notes/$userId');
  } catch (e) {
    print("EEEERRROR: ${e.toString()}");
  }
  return Future.error("");
}
