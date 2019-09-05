import 'package:flutter/material.dart';
import 'package:gank/history/history_page.dart';
import 'package:gank/welfare/welfare.dart';

/// 首页的抽屉
class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Center(
              child: Text(
                "Gank",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("福利"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WelfarePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text("干货历史"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));
            },
          ),
        ],
      ),
    );
  }
}
