import 'package:flutter/material.dart';

class Notebook extends StatefulWidget {
  const Notebook({super.key});

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height,
              child: Placeholder()),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                expands: true,
                minLines: null,
                maxLines: null,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            width: 3 * (MediaQuery.of(context).size.width) / 4,
            height: MediaQuery.of(context).size.height,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
