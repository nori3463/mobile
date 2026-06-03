import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_page.dart';
import 'memo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Memo> memos = [];

  @override
  void initState() {
    super.initState();
    loadMemos();
  }

  Future<void> loadMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('memos');

    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      setState(() {
        memos = decoded.map((e) => Memo.fromJson(e)).toList();
      });
    }
  }

  Future<void> saveMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = memos.map((m) => m.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString('memos', jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('メモ一覧')),
      body: memos.isEmpty
          ? Center(
              child: Text(
                '保存されているメモはありません',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: memos.length,
              itemBuilder: (context, index) {
                final memo = memos[index];
                return ListTile(
                  title: Text(memo.title),
                  subtitle: Text(
                    memo.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditPage(memo: memo),
                      ),
                    );

                    if (result == 'delete') {
                      setState(() {
                        memos.removeAt(index);
                      });
                      saveMemos();
                    } else if (result is Memo) {
                      setState(() {
                        memos[index] = result;
                      });
                      saveMemos();
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditPage(),
            ),
          );

          if (result is Memo) {
            setState(() {
              memos.add(result);
            });
            saveMemos();
          }
        },
      ),
    );
  }
}
