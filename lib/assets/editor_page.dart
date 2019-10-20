import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:share/share.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'dart:convert'; // access to jsonEncode()
import 'dart:io'; // access to File and Directory classes
import 'dart:convert' as JSON;

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
   void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return Scaffold(
      appBar: AppBar(title: Text("Editor page"),
        // <<< begin change
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveDocument(context),
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.share),
              onPressed: () => Share.share(_controller.document.toPlainText()),
            ),
            //   onPressed: () => Share.share(JSON.jsonDecode(jsonEncode(_controller.document))[0](0).toString()),
            // ),
          )
        ],
        // end change >>>
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     //onpressed func here.
        //     print();
            
        //   },
        //   child: Icon(Icons.share),
        //   backgroundColor: Colors.blue[400],
        // ),
    );
  }
  /// Loads the document to be edited in Zefyr.
  Future<NotusDocument> _loadDocument() async {
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    if (await file.exists()) {
      final contents = await file.readAsString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    final Delta delta = Delta()..insert("Zefyr Quick Start\n");
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final contents = jsonEncode(_controller.document);
    // For this example we save our document to a temporary file.
    final file = File(Directory.systemTemp.path + "/quick_start.json");
    // And show a snack bar on success.
    file.writeAsString(contents).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
    });
  }
}