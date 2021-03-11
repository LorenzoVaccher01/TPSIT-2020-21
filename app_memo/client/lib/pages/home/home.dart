import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _memos = [];
  String _error = "";

  @override
  void initState() {
    //TODO:
  }

    @override
  void dispose() {
    //TODO:
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
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
                    text: 'Memos',
                    style: TextStyle(
                      fontSize: 20,
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
        ),
        //drawer: Menu(),
        body: Container(
          margin: EdgeInsets.all(4),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) => new Container(
                padding: EdgeInsets.all(12),
                color: Color(0xffb74093),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 13),
                      child: Text('Titolo molto titoloso!',
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold)),
                    ),
                    Text(
                        'Questo è un testo molto testoso per testare l\'applicazione')
                  ],
                )),
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(Icons.add),
          onPressed: () {
            //TODO: creare modal per aggiunta nota
            //Navigator.pushNamed(context, '/contacts');
          },
        ),
      ),
    );
  }
}
