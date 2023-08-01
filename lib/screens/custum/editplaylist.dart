import 'package:flutter/material.dart';

import '../../db/box.dart';

// ignore: must_be_immutable
class EditPlaylist extends StatelessWidget {
  EditPlaylist({Key? key, required this.playlistName}) : super(key: key);
  final String playlistName;
  final _box = Boxes.getInstance();
  String? _title;
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Color.fromARGB(255, 94, 138, 129),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
              top: 20,
            ),
            child: Text(
              "Edit your playlist name.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: Form(
              key: formkey,
              child: TextFormField(
                initialValue: playlistName,
                cursorHeight: 25,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                onChanged: (value) {
                  _title = value;
                },
                validator: (value) {
                  List keys = _box.keys.toList();
                  if (value == "") {
                    return "Name Required";
                  }
                  if (keys.where((element) => element == value).isNotEmpty) {
                    return "This name already exits";
                  }
                  return null;
                },
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15,
                    top: 5,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15,
                    top: 5,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        List? playlists = _box.get(playlistName);
                        _box.put(_title, playlists!);
                        _box.delete(playlistName);
                        Navigator.pop(context);
                      }
                    },
                    child: const Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
