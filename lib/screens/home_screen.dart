import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';

import '../widgets/note_dialogs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> list = [];
  var hiveBox = Hive.box("MyNotes");

  //Method For Get All Data
  void _refreshData() {
    ////First Way

    // var data = box.keys.map(
    //   (key) {
    //     var value = box.get(key);
    //     return {"noteText": value["noteText"]};
    //   },
    // ).toList();

    // hive_list = data.reversed.toList();

    ////Second Way
    list = [];
    for (var keys in hiveBox.keys) {
      var value = hiveBox.get(keys);
      list.add({
        "key": keys,
        "noteText": value["noteText"],
        "dateTime": value["dateTime"]
      });
    }

    ////For By Ascending
    list.sort((a, b) => b['dateTime'].compareTo(a['dateTime']));

    ////For By Descending
    //hive_list.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));

    setState(() {});
  }

  //init State
  @override
  void initState() {
    _refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Project"),
        actions: [
          //Icon For Add Note
          IconButton(
              onPressed: () {
                showAddNoteBottomSheet(context, ((text) async {
                  await hiveBox
                      .add({"noteText": text, "dateTime": DateTime.now()});
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  _refreshData();
                }));
              },
              icon: const Icon(Icons.add_circle)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemExtent: 45,
                      itemCount: list.length,
                      itemBuilder: ((context, index) {
                        var noteIndex = list[index];
                        return Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.4,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${noteIndex["noteText"]}",
                                  style: const TextStyle(fontSize: 27),
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Row(
                              children: [
                                //Button For Update
                                IconButton(
                                    onPressed: () {
                                      showAddNoteBottomSheet(
                                        context,
                                        ((text) async {
                                          await hiveBox.put(noteIndex["key"], {
                                            "noteText": text,
                                            "dateTime": DateTime.now()
                                          });
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                          _refreshData();
                                        }),
                                        isText: noteIndex["noteText"],
                                      );
                                    },
                                    icon: const Icon(Icons.edit)),

                                //Button For Delete
                                IconButton(
                                    onPressed: () {
                                      showAlertDialog(context, (() async {
                                        // hive_list.removeAt(
                                        //     hive_list.length - 1 - index);
                                        // box.deleteAt(
                                        //     hive_list.length - index);

                                        await hiveBox.delete(noteIndex['key']);
                                        _refreshData();
                                      }));
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red)),
                              ],
                            ),
                          ],
                        );
                      })),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Method For Text View
  Widget _text(
      {String text = "",
      double textSize = 20,
      Color textColor = Colors.black,
      TextAlign textAlign = TextAlign.start,
      bool isBold = false}) {
    return Text(text,
        textAlign: textAlign,
        style: TextStyle(
            fontSize: textSize,
            color: textColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal));
  }

  //Method For Icon App Bar Button
  Widget _appBarButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
        onPressed: () {
          onPressed();
          setState(() {});
        },
        icon: Icon(icon));
  }
}
