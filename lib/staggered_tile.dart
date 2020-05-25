import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:multi_screen/notes.dart';
import 'package:multi_screen/utility.dart';
import 'package:multi_screen/note_page.dart';

class MyStaggeredTile extends StatefulWidget {
  final Note note;
  MyStaggeredTile(this.note);
  @override
  _MyStaggeredTileState createState() => _MyStaggeredTileState();
}

class _MyStaggeredTileState extends State<MyStaggeredTile> {
  String _content;
  double _fontSize;
  Color tileColor;
  String title;
  List labels;

  @override
  Widget build(BuildContext context) {
    _content = widget.note.content;
    _fontSize = _determineFontSizeForContent();
    tileColor = widget.note.noteColor;
    title = widget.note.title;
    labels = widget.note.labels;

    return InkWell(
      onTap: () => _noteTapped(context),
      child: Ink(
        decoration: BoxDecoration(
            border: tileColor == Colors.white
                ? Border.all(color: CentralStation.borderColor)
                : null,
            gradient: LinearGradient(colors: [
              tileColor.withOpacity(0.6),
              tileColor,
            ], begin: Alignment.topLeft, end: Alignment.bottomCenter,stops: [0.1,0.8]),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: EdgeInsets.all(12),
        child: constructChild(),
      ),
    );
  }

  void _noteTapped(BuildContext ctx) {
    CentralStation.updateNeeded = false;
    Navigator.push(
        ctx, MaterialPageRoute(builder: (ctx) => NotePage(widget.note)));
  }

  Widget constructChild() {
    List<Widget> contentsOfTiles = [];

    if (widget.note.title.length != 0) {
      contentsOfTiles.add(
        AutoSizeText(
          title,
          style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold),
          maxLines: widget.note.title.length == 0 ? 1 : 3,
          textScaleFactor: 1.5,
        ),
      );
      contentsOfTiles.add(
        Divider(
          color: widget.note.noteColor,
          height: 6,
        ),
      );
    }

    contentsOfTiles.add(AutoSizeText(
      _content,
      style: TextStyle(fontSize: _fontSize),
      maxLines: 10,
      textScaleFactor: 1.5,
    ));

    contentsOfTiles.add(
      Divider(
        color: widget.note.noteColor,
        height: 6,
      ),
    );
    contentsOfTiles.add(Align(
      alignment: Alignment.centerRight,
      child: Text(
        CentralStation.stringForDatetime(widget.note.dateLastEdited),
        textAlign: TextAlign.right,
      ),
    ));
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: contentsOfTiles);
  }

  double _determineFontSizeForContent() {
    int charCount = _content.length + widget.note.title.length;
    double fontSize = 16;
    if (charCount > 110) {
      fontSize = 8;
    } else if (charCount > 80) {
      fontSize = 10;
    } else if (charCount > 50) {
      fontSize = 12;
    } else if (charCount > 20) {
      fontSize = 14;
    }
    return fontSize;
  }
}
