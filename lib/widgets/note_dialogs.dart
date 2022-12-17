import 'package:flutter/material.dart';

Future showAddNoteBottomSheet(BuildContext context, Function(String) onPressed,
    {String isText = ""}) async {
  TextEditingController textController = TextEditingController(text: isText);
  return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: ((context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //Title
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text(isText.isNotEmpty ? "Edit Note" : "Add New Note")),
                //Text Field Controller
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: textController,
                      autocorrect: false,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(75, 48)),
                        onPressed: (() {
                          Navigator.pop(context);
                        }),
                        child: const Text("Cancel")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(75, 48)),
                        onPressed: (() {
                          onPressed(textController.text);
                        }),
                        child: Text(isText.isNotEmpty ? "Edit" : "Add")),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      }));
}

//Method Show Alert Dialog
showAlertDialog(BuildContext context, VoidCallback okPressed) {
  Widget buCancel = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("Cancel"));

  Widget buDelete = TextButton(
      onPressed: () {
        okPressed();
        Navigator.pop(context);
      },
      child: const Text("Delete", style: TextStyle(color: Colors.red)));

  AlertDialog alert = AlertDialog(
    title: const Text("Are You Sure To Delete This Note?"),
    actions: [buCancel, buDelete],
  );

  showDialog(
      context: context,
      builder: ((context) {
        return alert;
      }));
}
