import 'package:flutter/material.dart';
class layout1 extends StatefulWidget {
  const layout1({Key? key}) : super(key: key);

  @override
  State<layout1> createState() => _layout1State();
}

class _layout1State extends State<layout1> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        elevation: 0,
        actions: [
         Padding(padding: EdgeInsets.only(right: 10),child: Icon(Icons.settings),)
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),

                child: Card(
                  child: Container(
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [

          ],
        ),
      ),
    );
  }
}
