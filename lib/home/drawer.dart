/*
 * Copyright (c) 2015-2019 StoneHui
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:gank/history/history_page.dart';
import 'package:gank/submit/submit_gank_page.dart';
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
          ListTile(
            leading: Icon(Icons.image),
            title: Text("提交干货"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitGankPage()));
            },
          ),
        ],
      ),
    );
  }
}
