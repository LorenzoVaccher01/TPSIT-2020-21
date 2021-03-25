import 'package:memo/pages/home/views/category.dart';
import 'package:memo/pages/home/views/tag.dart';
import 'package:memo/pages/home/views/memo.dart';
import 'package:memo/utils/models/category.dart';
import 'package:memo/utils/models/memo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../../utils/models/tag.dart';

class HomeActionButton extends StatefulWidget {
  @override
  _HomeActionButtonState createState() => _HomeActionButtonState();
}

class _HomeActionButtonState extends State<HomeActionButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        tooltip: 'Add',
        icon: Icons.add,
        activeIcon: Icons.remove,
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.white,
        overlayOpacity: 0,
        children: [
          SpeedDialChild(
              child: Icon(Icons.tag),
              label: 'Tag',
              backgroundColor: Colors.deepOrange[300],
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TagPage(true, null, null, null, null, null)));

                if (result != null) {
                  await Tag.add(context, result['name'], result['description']);
                }
              }),
          SpeedDialChild(
              child: Icon(Icons.category),
              label: 'Category',
              backgroundColor: Colors.cyan[300],
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CategoryPage(true, null, null, null, null, null)));
                if (result != null) {
                  await Category.add(
                      context, result['name'], result['description']);
                }
              }),
          SpeedDialChild(
              child: Icon(Icons.note_add),
              label: 'Memo',
              backgroundColor: Colors.amber[300],
              onTap: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MemoPage(true, null)));

                if (result != null) {
                  await Memo.add(
                      context,
                      result['name'],
                      result['body'],
                      result['category'],
                      result['color'],
                      result['tags'],
                      result['accounts']);
                }
              }),
        ]);
  }
}
