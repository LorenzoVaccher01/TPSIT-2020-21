import 'package:memo/pages/home/views/tag.dart';
import 'package:memo/pages/home/widget/actionButton.dart';
import 'package:memo/pages/home/widget/menu.dart';
import 'package:memo/utils/models/tag.dart';
import 'package:memo/widget/alert.dart';
import 'package:flutter/material.dart';

class TagsPage extends StatefulWidget {
  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Tag> _tags = [];

  @override
  void initState() {
    _getTags();
    super.initState();
  }

  _getTags() async {
    _tags = await Tag.get(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _refreshTags() async {
      print('Refreshing tags...');
      _getTags();
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Menu(),
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 8.0,
            backgroundColor: Theme.of(context).primaryColor,
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: 'Tags',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.menu),
              iconSize: 25.0,
              color: Colors.white,
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            actions: [],
          ),
          body: Container(
            alignment: Alignment.center,
            child: _tags.length == 0
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/img/sad.png",
                            height: 90, width: 90),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        Text('No tags were found!',
                            style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        Padding(padding: EdgeInsets.only(top: 30)),
                        ElevatedButton.icon(
                            onPressed: () => _refreshTags(),
                            label: Text("Refresh"),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).accentColor,
                            ),
                            icon: Icon(Icons.refresh))
                      ],
                    ),
                  )
                : RefreshIndicator(
                  onRefresh: _refreshTags,
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                      itemCount: _tags.length,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemBuilder: (context, index) {
                        return InkWell(
                            child: Container(
                                padding: EdgeInsets.only(
                                    top: 8, left: 15, bottom: 8, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '#' + _tags[index]
                                                .name
                                                .substring(0, 1)
                                                .toUpperCase() +
                                            _tags[index].name.substring(1),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    InkWell(
                                        child: Icon(Icons.delete,
                                            size: 30, color: Colors.grey),
                                        onTap: () {
                                          Alert(
                                            context: context,
                                            closeButton: true,
                                            textConfirmButton: "Yes",
                                            textCanelButton: "No",
                                            onClick: () async {
                                              int status = await Tag.delete(context, _tags[index]);
                                              if (status == 1) {
                                                _tags.removeWhere((tag) =>
                                                      tag.id ==
                                                      _tags[index].id);
                                                  setState(() {});
                                              }
                                            },
                                            title: 'Alert',
                                            body: Text(
                                                "Do you really want to delete this tag?"),
                                          );
                                        })
                                  ],
                                )),
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TagPage(
                                          false,
                                          _tags[index].id,
                                          _tags[index].name,
                                          _tags[index].description,
                                          _tags[index].creationDate,
                                          _tags[index].lastModifiedDate)));
                              if (result != null) {
                                int status = await Tag.put(context, _tags[index].id, result['name'], result['description']);
                                if (status == 1) {
                                  _tags[index].name = result['name'];
                                    _tags[index].description =
                                        result['description'];
                                    setState(() {});
                                }
                              }
                            });
                      }),
                ),
          ),
          floatingActionButton:HomeActionButton(),
        ));
  }
}
